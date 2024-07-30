local utils = require("user.utils")

function CreateStyles()
	local filepath = vim.fn.expand("%:r")
	local filename = vim.fn.expand("%:t:r")
	local cssFile = filepath .. ".scss"

	vim.cmd('normal oimport styles from "./' .. filename .. '.scss";')
	vim.cmd("edit " .. cssFile)
	vim.cmd("vsplit " .. cssFile)
end
vim.cmd("command! CreateStyles lua CreateStyles()")

function CloseQuickFixOrBuffer()
	local window_count = vim.fn.winnr("$")
	for win_num = 1, window_count do
		local win = vim.fn.win_getid(win_num)
		local bnum = vim.fn.winbufnr(win_num)
		local type = vim.fn.getbufvar(bnum, "&buftype")
		local ftype = vim.fn.getbufvar(bnum, "&filetype")

		-- this should close floating windows, but isn't....
		if vim.api.nvim_win_get_config(win).relative == "" then
			vim.api.nvim_win_close(win, 0)
		elseif type == "quickfix" then
			utils.warn("closing quickfix")
			vim.cmd("cclose")
			return
		elseif type == "help" then
			utils.warn("closing help")
			vim.cmd("helpc")
			return
		elseif ftype == "GitBlame" then
			utils.warn("closing blame")
			pcall(function()
				vim.api.nvim_win_close(win, 0)
			end)
			return
			-- elseif type == 'terminal' then
			--   vim.cmd("close")
			--   return
		end
	end

	utils.warn("closing current")
	pcall(function()
		vim.api.nvim_win_close(0, 0)
	end)
end

function EscapePair()
	local closers = { ")", "]", "}", ">", "'", '"', "`", "," }
	local line = vim.api.nvim_get_current_line()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local after = line:sub(col + 1, -1)
	local closer_col = #after + 1
	local closer_i = nil
	for i, closer in ipairs(closers) do
		local cur_index, _ = after:find(closer)
		if cur_index and (cur_index < closer_col) then
			closer_col = cur_index
			closer_i = i
		end
	end
	if closer_i then
		vim.api.nvim_win_set_cursor(0, { row, col + closer_col })
	else
		vim.api.nvim_win_set_cursor(0, { row, col + 1 })
	end
end

if not vim.g.vscode then
	vim.api.nvim_set_keymap("i", "<C-l>", "<cmd>lua EscapePair()<CR>", { noremap = true, silent = true })
end

local function copy_migration_timestamp()
    -- Get the current file name
    local filename = vim.fn.expand('%:t')

    -- Match the timestamp in the filename
    local timestamp = filename:match("(%d+)_.*%.rb")

    if timestamp then
        -- Copy the timestamp to the macOS pasteboard
        vim.fn.system("echo '" .. timestamp .. "' | pbcopy")
        print("Timestamp " .. timestamp .. " copied to clipboard")
    else
        print("No timestamp found in the filename")
    end
end

-- Create a user command to run the function
vim.api.nvim_create_user_command('CopyMigrationTimestamp', copy_migration_timestamp, {})
