local status_ok, toggleterm = pcall(require, "toggleterm")
local ok, terms = pcall(require, "toggleterm.terminal")
local utils = require("user.utils")

if not status_ok then
	return
end

-- TODO: seperate consoles for rails console, specs, etc...
-- consider using vim for all primary project terminal stuff (e.g starting webpack)
-- https://github.com/sheodox/projectlaunch.nvim
--
-- pressing up arrow when not in insert should run last command?
-- telescope picker to search and execute from terminal history
-- how to handle copy/paste in terminal buffer? (c-w N)
-- add binding to toggle vertical size between default and 50%
-- fix ctrl- nav commands
-- add normal mode   to kill/continue term

function file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

local shell = file_exists("/usr/local/bin/fish") and "/usr/local/bin/fish" or "/opt/homebrew/bin/fish"

toggleterm.setup({
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.33
		end
	end,
	open_mapping = [[<c-\>]],
	auto_scroll = true,
	hide_numbers = true,
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	shell = shell,
	float_opts = {
		border = "double",
		width = 200,
		height = 200,
		winblend = 10,
	},
})

function no_normal(term)
	pcall(function()
		vim.api.nvim_buf_del_keymap(0, "t", "<esc>")
	end)

	pcall(function()
		vim.api.nvim_buf_set_keymap(0, "t", "<esc><esc>", "<cmd>close<CR>", { silent = true, noremap = true })
	end)
end

function watch_yarn(t, _, data, _)
	for k, line in pairs(data) do
		if line:match("ERROR") then
			str = line:gsub("%[%dm", "")
			-- [1m[31mERROR[39m[22m in [1m./ui/index.js[39m[22m

			utils.errorlog(str, "Webpack ERROR")
		else
			-- utils.log(line)
		end
	end
	-- ERROR in ./ui/components/changesets/Changeset.js
	-- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
	-- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
end

local Terminal = terms.Terminal
local lazygit = Terminal:new({
	cmd = "lazygit",
	dir = "git_dir",
	direction = "float",
	float_opts = {
		border = "double",
	},
	-- function to run on opening the terminal
	on_open = function(term)
		no_normal()
		vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(term.bufnr, "t", "q", "<cmd>close<CR>", { noremap = true, silent = true })

		pcall(vim.api.nvim_buf_del_keymap, term.bufnr, "i", "<c-h>")
		pcall(vim.api.nvim_buf_del_keymap, term.bufnr, "i", "<c-j>")
		pcall(vim.api.nvim_buf_del_keymap, term.bufnr, "i", "<c-k>")
		pcall(vim.api.nvim_buf_del_keymap, term.bufnr, "i", "<c-l>")

		pcall(vim.api.nvim_buf_del_keymap, term.bufnr, "t", "<c-h>")
		pcall(vim.api.nvim_buf_del_keymap, term.bufnr, "t", "<c-j>")
		pcall(vim.api.nvim_buf_del_keymap, term.bufnr, "t", "<c-k>")
		pcall(vim.api.nvim_buf_del_keymap, term.bufnr, "t", "<c-l>")

		vim.api.nvim_buf_set_keymap(term.bufnr, "i", "<c-j>", "<Right>", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<c-j>", "<Right>", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(term.bufnr, "i", "<c-k>", "<Left>", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<c-j>", "<Right>", { noremap = true, silent = true })

		vim.api.nvim_buf_set_keymap(term.bufnr, "i", "<c-h>", "[", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<c-h>", "[", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(term.bufnr, "i", "<c-h>", "[", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<c-h>", "[", { noremap = true, silent = true })
	end,
	-- function to run on closing the terminal
	on_close = function(term)
		vim.cmd("startinsert!")
	end,
})

local rails_console = Terminal:new({ cmd = "rails console", direction = "vertical" })
local start = Terminal:new({
	cmd = "yarn start",
	hidden = true,
	direction = "float",
	on_stdout = watch_yarn,
	on_open = function(term)
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<esc><esc>", "<cmd>close<CR>", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc><esc>", "<cmd>close<CR>", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(term.bufnr, "t", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
})

function _LAZYGIT_TOGGLE()
	lazygit:toggle()
	lazygit.display_name = "Git"
end

function _RAILS_CONSOLE_TOGGLE()
	rails_console:toggle()
end

function _TOGGLE_TERMINAL_DIR()
	local term = terms.get(terms.get_toggled_id())

	if not term then
		return
	end

	local is_float = term:is_float()

	term:close()

	if is_float then
		term:change_direction("vertical")
	else
		term:change_direction("float")
	end

	term:open()
end

function _START_APP_TOGGLE()
	start:toggle()
end

function _TERMINAL_EOD()
	toggleterm.exec_command("cmd='' go_back=1")
end

function _GIT_SHOW(sha)
	local term = Terminal:new({
		cmd = "git show " .. sha,
		hidden = true,
		close_on_exit = false,
		direction = "float",
		go_back = 0,
		start_in_insert = true,
	})
	term:open()
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
