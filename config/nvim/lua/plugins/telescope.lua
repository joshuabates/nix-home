if not vim.g.vscode then
	return {
		"nvim-telescope/telescope.nvim",
		-- use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
		"natecraddock/telescope-zf-native.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		"tknightz/telescope-termfinder.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
	}
end
