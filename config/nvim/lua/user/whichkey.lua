local wk = require("which-key")

wk.register({
	g = {
		name = "Go",

		-- % - cycle results
		-- b,c comment toggl
		-- x open w/ system app
		-- ' marks
		e = "End of prev word",
		f = "File",
		g = "First line",
		i = "Last insert",
		p = "Last paste",
		v = "Last selection",
		u = "Lowercase",
		U = "Uppercase",

		r = "References",
		d = "Definition",
		D = "Decleration",
		I = "Implementation",
		h = "Help doc",

		x = "Diagnostics",

		-- todo

		-- make a g1, g2, g3, etcc for window navigation?
	},
})
wk.register({
	["<leader>\\"] = {
		name = "Terminals",

		r = { "<cmd>lua _RAILS_CONSOLE_TOGGLE()<CR>", "Rails Console (Float)" },
		a = { "<cmd>lua _START_APP_TOGGLE()<CR>", "Start App" },
		g = { "<cmd>lua _LAYGIT_TOGGLE()<CR>", "Lazygit" },
		t = { "<cmd>lua _TOGGLE_TERMINAL_DIR()<CR>", "Toggle Float" },

		c = { "<cmd>lua _TERMINAL_EOD()<CR>", "Continue" },
		x = { "<cmd>lua _TERMINAL_EOD()<CR>", "Kill" },

		p = { "<cmd>ToggleTermSendCurrentLine<CR>", "Paste Current Line" },
		v = { "<cmd>ToggleTermSendVisualSelection<CR>", "Paste Visual Selection" },
		-- p = "Rails REPL",
		-- TODO: Test
	},
	["<leader>."] = {
		name = "Edittor something...",
	},
	["<leader>,"] = {
		name = "Edit or something...",
	},
})

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
keymap("n", "<leader>f<space>", "<cmd>Telescope find_files<cr>", opts)

-- keymap("qf", "dd", "<Tab>zN", opts)
wk.register({
	-- TODO: customize list for text objects
	-- v = {
	--   name = "Visual"
	-- },
	-- y = {
	--   name = "Yank"
	-- },
	-- c = {
	--   name = "Change"
	-- },
	-- d = {
	--   name = "Delete"
	-- },

	f = {
		name = "Find",

		-- keymap("n", "<leader>fc", "<cmd>Telescope termfinder find<cr>", opts)

		f = { "<cmd>Telescope find_files<cr>", "File" },
		d = {
			"<cmd>lua require('telescope.builtin').find_files({ previewer = false, find_command = { 'fd', '--type', 'd' }, prompt_title = '"
				.. find_in_dir_prompt
				.. "'})<cr>",
			"In Dir (<CR> find_file in DIR, <C-s> grep)",
		},
		m = { "<cmd>Telescope lsp_document_symbols<cr>", "Method" },
		b = {
			"<cmd>lua require('telescope.builtin').buffers({ sort_mru = true, ignore_current_buffer = true })<cr>",
			"Buffer",
		},
		w = { "<cmd>lua require('telescope.builtin').grep_string({search = vim.fn.expand('<cword>')})<cr>", "Word" },
		s = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Search" },
		h = { "<cmd>lua require('telescope.builtin').search_history()<cr>", "Search History" },
		q = { "<cmd>lua require('telescope.builtin').quickfixhistory()<cr>", "Quickfix History" },
		Q = { "<cmd>lua require('telescope.builtin').quickfix()<cr>", "Quickfix" },
		l = { "<cmd>Telescope resume<cr>", "Last Search" },
		-- ['\\'] = { "<cmd>Telescope termfinder find<cr>", "Terminal" }, -- TODO: this doesn't list any of my custom terms (which are the only ones I care about here)
		e = { "<cmd>lua vim.lsp.buf.references()<CR>", "Reference" },
		g = {
			name = "Git",
			b = { "<cmd>lua require('telescope.builtin').git_branches()<cr>", "Branches" },
			c = { "<cmd>lua require('telescope.builtin').git_commits()<cr>", "Commits" },
			f = { "<cmd>lua require('telescope.builtin').git_bcommits()<cr>", "Buffer Commits" },
			s = { "<cmd>lua require('telescope.builtin').git_stash()<cr>", "Stashes" },
		},
		r = {
			name = "Rails",
			m = { "<cmd>Telescope find_files cwd=app/models<Cr>", "Model" },
			c = { "<cmd>Telescope find_files cwd=app/controllers<Cr>", "Controller" },
			s = { "<cmd>Telescope find_files cwd=spec<Cr>", "Spec" },
		},
	},

	g = {
		name = "Git",

		-- TODO: figure out how to add a hover to show full commit message and enter to view commit diff
		-- b = { "<cmd>lua require('agitator').git_blame({sidebar_width=40})<CR>", "Blame"},
		-- b = { '<cmd>lua require("user.blame").open()<CR>', 'Blame' },
		b = { "<cmd>Git blame<CR>", "Blame" },
		-- vim.keymap.set('n', '<leader>c', ":lua require('plugins.telescope').my_git_commits()<CR>", {noremap = true, silent = true})
		-- vim.keymap.set('n', '<leader>g', ":lua require('plugins.telescope').my_git_status()<CR>", {noremap = true, silent = true})
		-- vim.keymap.set('n', '<leader>b', ":lua require('plugins.telescope').my_git_bcommits()<CR>", {noremap = true, silent = true})
		-- b = { "<cmd>Git blame<CR>", "Blame"},
		v = { ":lua ShowCommitAtLine()<cr>", "View commit" },
		t = { "<cmd>lua require('agitator').git_time_machine()<CR>", "Time Machine" },
		g = "Lazygit",
		y = "Copy github link",

		h = { "<Cmd>DiffviewFileHistory %.<CR>", "History" },

		-- b = { "<Cmd>VGit buffer_blame_preview<CR>", "Blame" },
		-- d = { "<Cmd>VGit buffer_diff_preview<CR>", "Diff" },
		-- h = { "<Cmd>VGit buffer_history_preview<CR>", "History" },

		-- nnoremap('<leader>gs', '<Cmd>VGit buffer_stage<CR>')
		-- nnoremap('<leader>gr', '<Cmd>VGit buffer_reset<CR>')
		-- nnoremap('<leader>gp','<Cmd>VGit buffer_hunk_preview<CR>')
		-- nnoremap('<leader>gu','<Cmd>VGit buffer_reset<CR>')
		-- nnoremap('<leader>gg','<Cmd>VGit buffer_gutter_blame_preview<CR>')
		-- nnoremap('<leader>gl','<Cmd>VGit project_hunks_preview<CR>')
		-- nnoremap('<leader>gd','<Cmd>VGit project_diff_preview<CR>')
		-- nnoremap('<leader>gq','<Cmd>VGit project_hunks_qf<CR>')
		-- nnoremap('<leader>gx','<Cmd>VGit toggle_diff_preference<CR>')
	},
	h = {
		name = "Help / Docs",

		c = { "<cmd>lua require('telescope.builtin').commands()<cr>", "Commands" },
		h = { "<cmd>lua require('telescope.builtin').help_tags()<cr>", "Help" },
	},
	q = {
		name = "Quickfix",

		o = { "<cmd>copen<CR>", "Open" },
		r = { "<cmd>zN<CR>", "Remove tagged" },
		s = { "<cmd>zn<CR>", "Select tagged" },
		y = { "<cmd>lua _G.add_current_line_to_qf()<CR>", "Add" },

		["<"] = { "<cmd><<CR>", "Last QF" },
		[">"] = { "<cmd>><CR>", "Next QF" },
	},
	r = {
		--- Testing
		name = "Run",
		n = { "<cmd>TestNearest<cr>", "Nearest" },
		N = { "<cmd>TestNearest<cr>", "Nearest (background)" },
		s = { "<cmd>TestFile<cr>", "File" },
		S = { "<cmd>TestFile<cr>", "File (background)" },
		l = { "<cmd>TestLast<cr>", "Last" },
		L = { "<cmd>TestLast<cr>", "Last (background)" },
		g = { "<cmd>TestVisit<cr>", "Goto Last Spec" },
		-- a = { "<cmd>Test", "Attach"},
		-- d = { "<cmd>Test", "Debug"},
		-- TestSuite - run the whole test suite
		-- TestEdit - edit tests for the current file
		-- TestVisit - open the last run test in the current buffer
		-- s = {"Stop"},
		-- o = {"Overview"},
		-- p = {"Print"}
		-- keymap("n", "<leader>rf", function()
		--   require("neotest").run.run(vim.fn.expand("%"))
		-- end) -- run file
		-- keymap("n", "<leader>rn", function()
		--   require("neotest").run.run()
		-- end) -- run nearest test
		-- keymap("n", "<leader>ra", function()
		--   require("neotest").run.attach()
		-- end)
		-- keymap("n", "<leader>rd", function()
		--   require("neotest").run.run({ strategy = "dap" })
		-- end) -- debug nearest test
		-- keymap("n", "<leader>rl", function()
		--   require("neotest").run.run_last()
		-- end) -- run last test
		-- keymap("n", "<leader>rs", function()
		--   require("neotest").run.stop()
		-- end)
		-- keymap("n", "<leader>ro", function()
		--   require("neotest").summary.toggle()
		-- end)
		-- keymap("n", "<leader>rp", function()
		--   require("neotest").output.open({ enter = true })
		-- end)
	},
	s = {
		name = "?",

		-- w = "Current Word",
		-- g = "Grep"
	},
	v = {
		name = "Vim",

		c = { "<cmd>e $MYVIMRC<CR>", "Open Config" },
		l = { "<cmd>lazy<CR>", "Lazy" },
		r = { "<cmd>Reload<CR>", "Reload" },
		R = { "<cmd>Restart<CR>", "Restart" },
	},
}, { prefix = "<leader>" })
