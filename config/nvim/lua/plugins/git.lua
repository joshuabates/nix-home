if not vim.g.vscode then
	return {
		"lewis6991/gitsigns.nvim",
		{
			"ruifm/gitlinker.nvim",
			requires = "nvim-lua/plenary.nvim",
			config = function()
				require("gitlinker").setup()
			end,
		},

		-- use { 'rhysd/git-messenger.vim' }
		-- use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
		{ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" },

		"tpope/vim-fugitive",
	}
end
