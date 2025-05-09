local M = {}

-- Add import function to automatically import the identifier under cursor
M.add_import = function()
    local params = vim.lsp.util.make_position_params()
    local method = "textDocument/codeAction"

    -- Filter for import actions only
    local filter = {
        context = {
            only = {
                "source.addImport",
                "source.addMissingImports",
                "source.fixAll.imports"
            },
            diagnostics = vim.diagnostic.get(0)
        }
    }
    params = vim.tbl_extend("force", params, filter)

    vim.lsp.buf_request(0, method, params, function(err, result, ctx, config)
        if err or not result or vim.tbl_isempty(result) then
            -- Try the generic import fixer if specific import actions aren't available
            params.context = { only = { "source.fixAll.imports" } }
            vim.lsp.buf_request(0, method, params, function(err2, result2)
                if err2 or not result2 or vim.tbl_isempty(result2) then
                    -- Try one last attempt with typescript-tools specific import action
                    params.context = { only = { "quickfix.import" } }
                    vim.lsp.buf_request(0, method, params, function(err3, result3)
                        if err3 or not result3 or vim.tbl_isempty(result3) then
                            vim.notify("No import actions available", vim.log.levels.INFO)
                            return
                        end
                        if result3[1].edit then
                            vim.lsp.util.apply_workspace_edit(result3[1].edit, "UTF-8")
                        elseif result3[1].command then
                            vim.lsp.buf.execute_command(result3[1].command)
                        end
                    end)
                    return
                end

                if result2[1].edit then
                    vim.lsp.util.apply_workspace_edit(result2[1].edit, "UTF-8")
                elseif result2[1].command then
                    vim.lsp.buf.execute_command(result2[1].command)
                end
            end)
            return
        end

        -- Apply the first available import action
        if result[1].edit then
            vim.lsp.util.apply_workspace_edit(result[1].edit, "UTF-8")
        elseif result[1].command then
            vim.lsp.buf.execute_command(result[1].command)
        end
    end)
end

return M
