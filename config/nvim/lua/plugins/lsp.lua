if vim.g.vscode then
  return {}
end

local icons = require("user/icons")

return {
  "ray-x/lsp_signature.nvim",
  {
    "rachartier/tiny-code-action.nvim",
    enabled = false,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    event = "LspAttach",
    opts = {
      backend = "vim",
      picker = {
        "snacks",
      },
    },
    keys = {
      {
        "<leader>la",
        function()
          require("tiny-code-action").code_action()
        end,
        desc = "Code Actions"
      }
    }
  },
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
    end,
    keys = {
      {
        "<leader>lr",
        function()
          local inc_rename = require("inc_rename")
          return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "Rename (inc-rename.nvim)",
      }
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
    config = function()
      require("typescript-tools").setup({
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          -- vim.lsp.inlay_hint.enable(true)
        end,
        settings = {
          tsserver_max_memory = 8192,
          separate_diagnostic_server = true,
          -- expose_as_code_action = "all",
          code_lens = "off",
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeCompletionsForModuleExports = true,
            quotePreference = "auto",
          },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { 'saghen/blink.cmp' },
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      -- { "<leader>ld", function() _G.toggle_diagnostics() end,              desc = "Toggle diagnostics" },
      { "<leader>li", "<cmd>LspInfo<cr>",                                      desc = "LSP Information" },
      { "<leader>la", function() vim.lsp.buf.code_action() end,                desc = "Code Actions" },
      { "<leader>la", function() vim.lsp.buf.code_action() end,                desc = "Code Actions",                mode = "v" },
      { "<leader>lj", function() vim.diagnostic.goto_next({ buffer = 0 }) end, desc = "Next Diagnostic" },
      { "<leader>lk", function() vim.diagnostic.goto_prev({ buffer = 0 }) end, desc = "Previous Diagnostic" },
      -- { "<leader>lr", function() vim.lsp.buf.rename() end,                     desc = "Rename Symbol" },
      { "<leader>ls", function() vim.lsp.buf.signature_help() end,             desc = "Signature Help" },
      { "<leader>lq", function() vim.diagnostic.setloclist() end,              desc = "Diagnostics to Location List" },

      -- { "gD",         function() vim.lsp.buf.declaration() end,                desc = "Go to Declaration" },
      { "gI",         function() vim.lsp.buf.implementation() end,             desc = "Go to Implementation" },
      { "gx",         function() vim.diagnostic.open_float() end,              desc = "Show Diagnostics" },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local utils = require("user.utils")

      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
          },
        },
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, false))

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua or {}, {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME }
            }
          })
        end,
      })

      lspconfig.yamlls.setup({
        capabilities = capabilities,
        cmd = utils.maybe_yarn_cmd("yaml-language-server", { "--stdio" }),
      })

      lspconfig.jsonls.setup({
        capabilities = capabilities,
        cmd = utils.maybe_yarn_cmd("vscode-json-language-server", { "--stdio" }),
      })

      lspconfig.cssls.setup({
        capabilities = capabilities,
        cmd = utils.maybe_yarn_cmd("vscode-css-language-server", { "--stdio" }),
      })

      lspconfig.stylelint_lsp.setup({
        capabilities = capabilities,
        cmd = utils.maybe_yarn_cmd("stylelint-lsp", { "--stdio" }),
        filetypes = { "css", "scss", "less", "sass" },
      })

      lspconfig.cssmodules_ls.setup({
        capabilities = capabilities,
        cmd = utils.maybe_yarn_cmd("cssmodules-language-server"),
      })

      lspconfig.ruby_lsp.setup({
        capabilities = capabilities,
        cmd = utils.maybe_gem_cmd("ruby-lsp"),
        init_options = {
          enabledFeatures = {
            diagnostics = false,
            formatter = false,
          }
        },
        settings = {
          ruby_lsp = {
            autoformat = false,
            completion = true,
            diagnostics = false,
            folding = false,
            references = true,
            rename = true,
          }
        }
      })

      lspconfig.standardrb.setup({
        capabilities = capabilities,
        cmd = utils.maybe_gem_cmd("standard", { "--lsp" }),
      })

      local function setup_js_linters()
        local has_biome = vim.fn.filereadable(vim.fn.getcwd() .. "/biome.json") == 1

        if has_biome then
          lspconfig.biome.setup({
            cmd = utils.maybe_yarn_cmd("biome", { "lsp-proxy" }),
            -- capabilities = capabilities,
            -- root_dir = lspconfig.util.root_pattern("biome.json"),
            -- Only use biome for diagnostics, not formatting
            -- on_attach = function(client)
            -- client.server_capabilities.documentFormattingProvider = false
            -- client.server_capabilities.documentRangeFormattingProvider = false
            -- end
          })
        else
          lspconfig.eslint.setup({
            autostart = true,
            capabilities = capabilities,
            -- cmd = utils.maybe_yarn_cmd("eslint_d", { "--stdin" }),
            on_attach = function(client)
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
            end
          })
        end
      end

      setup_js_linters()
    end,
  },
  {
    "stevearc/conform.nvim",
    ft = { "lua", "vue", "typescript", "typescriptreact", "javascript", "javascriptreact", "json", "jsonc", "ruby" },
    opts = {
      log_level = vim.log.levels.DEBUG,
      formatters = {
        biome = {
          -- args = { "format" },
          args = { "format", "--stdin-file-path", "$FILENAME" },
        }
      },
      formatters_by_ft = {
        -- lua = { "stylua" },
        css = { "biome", lsp_format = "prefer" },
        javascript = { "biome", "eslint_d", stop_after_first = true, lsp_format = "prefer" },
        javascriptreact = { "biome", "eslint_d", stop_after_first = true, lsp_format = "prefer" },
        json = { "biome", lsp_format = "prefer" },
        ruby = { "standardrb", lsp_format = "prefer" },
        typescript = { "biome", "eslint_d", "prettier", stop_after_first = true, lsp_format = "prefer" },
        typescriptreact = { "biome", "eslint_d", "prettier", stop_after_first = true, lsp_format = "prefer" },
      },
      format_on_save = {
        timeout_ms = 5000,
        lsp_format = "prefer",
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },
}
