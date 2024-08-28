-- TODO: Just use whichkey for all my keymaps?
-- that would be built in docs. Only issue is if I want to move away from it

--
-- What are the single mod-key actions I need to take?
-- (w?) saving # w would be a better window group
-- (x) closing window
-- zoom/focus
-- quick terminal
-- find file?
-- TODO: Settle on prefix(es) and groupings for search/find/lookup
-- leader f - first there are file find operations by name
-- leader s? or just part of f? - then file find ops by content (search)
--
-- g then there are operations based on a word, file or context
-- find references for this symbol
-- grep for this word
-- doc for this word
--
-- should there just be a single prefix key for all context related operations
-- surround
-- move
-- transformations (uppercase, etc..)
-- .... the g key already does some of this, but it's never become part of my muscle memory...
-- using leader-g wou

local keymap = vim.keymap.set
local opts = { silent = true }

vim.api.nvim_del_keymap('n', 'gt')
-- vim.api.nvim_del_keymap('n', 'gT')

keymap("i", "<F1>", "<Esc>", opts)
keymap("n", "<F1>", "<Esc>", opts)

if not vim.g.vscode then
	keymap("", "<Space>", "<Nop>", opts)
end

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

keymap("n", "<leader>ww", ":w<CR>", opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("n", "Q", "<Nop>", opts)

local function getVisualSelection()
	local start = vim.fn.getpos("v")
	local finish = vim.fn.getcurpos()
	return start, finish
end

if vim.g.vscode then
	-- keymap("n", "<leader><t>", ":call VSCodeNotify('workbench.action.quickOpen')<CR>", opts)
	-- keymap("n", "<leader><leader>", ":call VSCodeNotify('workbench.action.openPreviousRecentlyUsedEditor')<CR>", opts)
	keymap("n", "<leader>", ":call VSCodeNotify('whichkey.show')<CR>", opts)
	keymap("x", "<leader>", function()
		local start, finish = getVisualSelection()
		if vim.fn.mode() == "V" then
			require("vscode-neovim").notify_range("vspacecode.space", start[2], finish[2], 1)
		else
			require("vscode-neovim").notify_range_pos("vspacecode.space", start[2], finish[2], start[3], finish[3], 1)
		end
	end)
else
	-- " Switch between files with leader-leader
	keymap("n", "<leader><leader>", "<C-^>", opts)
	-- Comment
	local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
	keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>j", opts)
	keymap("x", "<leader>/", function()
		vim.api.nvim_feedkeys(esc, "nx", false)
		require("Comment.api").toggle.linewise(vim.fn.visualmode())
		vim.cmd("norm! j")
	end)
end
--
-- " Select last pasted block
keymap("n", "gp", "`[v`]", opts)

-- "This unsets the "last search pattern" register by hitting return
keymap("n", "<CR>", ":noh<CR><CR>", opts)

-- TODO
-- "gF goto file @ line#
-- keymap("n", "<Leader>p", ":let @+ = expand('%:.') . ':' . line('.')<CR>", opts)

-- keymap("n", "<leader>v", ":source $MYVIMRC<CR>", opts)
keymap("n", "<leader>ww", ":wa<cr>", opts)

-- " Cycle through lines in the quickfix list
keymap("n", "<leader>j", ":w<CR>:cn<CR>", opts)
keymap("n", "<leader>k", ":w<CR>:cp<CR>", opts)
-- " Cycle through files in the quickfix list
keymap("n", "<leader>J", ":w<CR>:cN<CR>", opts)
keymap("n", "<leader>K", ":w<CR>:cP<CR>", opts)

-- Git
keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)
keymap("n", "<leader>x", "<cmd>lua CloseQuickFixOrBuffer()<CR>", opts)
keymap("n", "<leader>z", "<cmd>ZenMode<cr>", opts)


-- Trouble / Quicklist / Diagnostics

if not vim.g.vscode then
	local find_in_dir_prompt = require("user.telescope").find_in_dir_prompt
	local wk = require("which-key")

	-- Fix window navigation in netrw buffers
	function set_netrw_keymaps()
		local opts = { silent = true, buffer = true }
		keymap("n", "<C-h>", ":wincmd h<cr>", opts)
		keymap("n", "<C-j>", ":wincmd j<cr>", opts)
		keymap("n", "<C-k>", ":wincmd k<cr>", opts)
		keymap("n", "<C-l>", ":wincmd l<cr>", opts)
	end

	vim.cmd("autocmd! filetype netrw lua set_netrw_keymaps()")

	function set_terminal_keymaps()
		local opts = { noremap = true }

		vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)

		-- vim.api.nvim_buf_set_keymap(0, 't', '<Up>', [[<C-\><C-n><C-W>l]], opts)

		vim.api.nvim_buf_set_keymap(0, "i", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
		vim.api.nvim_buf_set_keymap(0, "i", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
		vim.api.nvim_buf_set_keymap(0, "i", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
		vim.api.nvim_buf_set_keymap(0, "i", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
	end
	if not vim.g.vscode then
		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
	end
	-- Telescope
	keymap("n", "<leader>t", "<cmd>Telescope find_files<cr>", opts)
	keymap(
		"n",
		"<leader>b",
		"<cmd>lua require('telescope.builtin').buffers({ sort_mru = true, ignore_current_buffer = true })<cr>",
		opts
	)

	keymap("n", "<leader>f<space>", "<cmd>Telescope find_files<cr>", opts)

	wk.add({
    { "g", group = "Go" },
    { "gD", desc = "Decleration" },
    { "gI", desc = "Implementation" },
    { "gU", desc = "Uppercase" },
    { "gd", desc = "Definition" },
    { "ge", desc = "End of prev word" },
    { "gf", desc = "File" },
    { "gg", desc = "First line" },
    { "gh", desc = "Help doc" },
    { "gi", desc = "Last insert" },
    { "gp", desc = "Last paste" },
    { "gr", desc = "References" },
    { "gu", desc = "Lowercase" },
    { "gv", desc = "Last selection" },
    { "gx", desc = "Diagnostics" },

    { "<leader>w", group = "Window" },
    { "<leader>ww", desc = "Save File" },
    { "<leader>we",
      function()
        require("neo-tree.command").execute({ toggle = true })
      end,
      desc = "Toggle Explorer"
    },
    { "<leader>\\", group = "Terminals" },
    { "<leader>\\a", "<cmd>lua _START_APP_TOGGLE()<CR>", desc = "Start App" },
    { "<leader>\\c", "<cmd>lua _TERMINAL_EOD()<CR>", desc = "Continue" },
    { "<leader>\\g", "<cmd>lua _LAYGIT_TOGGLE()<CR>", desc = "Lazygit" },
    { "<leader>\\p", "<cmd>ToggleTermSendCurrentLine<CR>", desc = "Paste Current Line" },
    { "<leader>\\r", "<cmd>lua _RAILS_CONSOLE_TOGGLE()<CR>", desc = "Rails Console (Float)" },
    { "<leader>\\t", "<cmd>lua _TOGGLE_TERMINAL_DIR()<CR>", desc = "Toggle Float" },
    { "<leader>\\v", "<cmd>ToggleTermSendVisualSelection<CR>", desc = "Paste Visual Selection" },
    { "<leader>\\x", "<cmd>lua _TERMINAL_EOD()<CR>", desc = "Kill" },

    { "<leader>f", group = "Find" },
    { "<leader>fQ", "<cmd>lua require('telescope.builtin').quickfix()<cr>", desc = "Quickfix" },
    { "<leader>fb", "<cmd>lua require('telescope.builtin').buffers({ sort_mru = true, ignore_current_buffer = true })<cr>", desc = "Buffer" },
    { "<leader>fd", "<cmd>lua require('telescope.builtin').find_files({ previewer = false, find_command = { 'fd', '--type', 'd' }, prompt_title = 'Find file/grep (<c-s>) in directory'})<cr>", desc = "In Dir (<CR> find_file in DIR, <C-s> grep)" },
    { "<leader>fe", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "Reference" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "File" },
    { "<leader>fg", group = "Git" },
    { "<leader>fgb", "<cmd>lua require('telescope.builtin').git_branches()<cr>", desc = "Branches" },
    { "<leader>fgc", "<cmd>lua require('telescope.builtin').git_commits()<cr>", desc = "Commits" },
    { "<leader>fgf", "<cmd>lua require('telescope.builtin').git_bcommits()<cr>", desc = "Buffer Commits" },
    { "<leader>fgs", "<cmd>lua require('telescope.builtin').git_stash()<cr>", desc = "Stashes" },
    { "<leader>fh", "<cmd>lua require('telescope.builtin').search_history()<cr>", desc = "Search History" },
    { "<leader>fl", "<cmd>Telescope resume<cr>", desc = "Last Search" },
    { "<leader>fm", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Method" },
    { "<leader>fq", "<cmd>lua require('telescope.builtin').quickfixhistory()<cr>", desc = "Quickfix History" },
    { "<leader>fr", group = "Rails" },
    { "<leader>frc", "<cmd>Telescope find_files cwd=app/controllers<Cr>", desc = "Controller" },
    { "<leader>frm", "<cmd>Telescope find_files cwd=app/models<Cr>", desc = "Model" },
    { "<leader>frs", "<cmd>Telescope find_files cwd=spec<Cr>", desc = "Spec" },
    { "<leader>fs", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "Search" },
    { "<leader>fw", "<cmd>lua require('telescope.builtin').grep_string({search = vim.fn.expand('<cword>')})<cr>", desc = "Word" },
    { "<leader>g", group = "Git" },
    { "<leader>gb", "<cmd>Git blame<CR>", desc = "Blame" },
    { "<leader>gg", desc = "Lazygit" },
    { "<leader>gh", "<Cmd>DiffviewFileHistory %.<CR>", desc = "History" },
    { "<leader>gt", "<cmd>lua require('agitator').git_time_machine()<CR>", desc = "Time Machine" },
    { "<leader>gv", ":lua ShowCommitAtLine()<cr>", desc = "View commit" },
    { "<leader>gy", desc = "Copy github link" },
    { "<leader>h", group = "Help / Docs" },
    { "<leader>hc", "<cmd>lua require('telescope.builtin').commands()<cr>", desc = "Commands" },
    { "<leader>hh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", desc = "Help" },
    { "<leader>q", group = "Quickfix" },
    { "<leader>q<", "<cmd><<CR>", desc = "Last QF" },
    { "<leader>q>", "<cmd>><CR>", desc = "Next QF" },
    { "<leader>qo", "<cmd>copen<CR>", desc = "Open" },
    { "<leader>qr", "<cmd>zN<CR>", desc = "Remove tagged" },
    { "<leader>qs", "<cmd>zn<CR>", desc = "Select tagged" },
    { "<leader>qy", "<cmd>lua _G.add_current_line_to_qf()<CR>", desc = "Add" },
    { "<leader>r", group = "Run" },
    { "<leader>rL", "<cmd>TestLast<cr>", desc = "Last (background)" },
    { "<leader>rN", "<cmd>TestNearest<cr>", desc = "Nearest (background)" },
    { "<leader>rS", "<cmd>TestFile<cr>", desc = "File (background)" },
    { "<leader>rg", "<cmd>TestVisit<cr>", desc = "Goto Last Spec" },
    { "<leader>rl", "<cmd>TestLast<cr>", desc = "Last" },
    { "<leader>rn", "<cmd>TestNearest<cr>", desc = "Nearest" },
    { "<leader>rs", "<cmd>TestFile<cr>", desc = "File" },
    { "<leader>s", group = "?" },
    { "<leader>v", group = "Vim" },
    { "<leader>vR", "<cmd>Restart<CR>", desc = "Restart" },
    { "<leader>vc", "<cmd>e $MYVIMRC<CR>", desc = "Open Config" },
    { "<leader>vl", "<cmd>lazy<CR>", desc = "Lazy" },
    { "<leader>vr", "<cmd>Reload<CR>", desc = "Reload" },
	})
end
