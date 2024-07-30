local status_ok, configs = pcall(require, "nvim-treesitter.configs")
-- if not status_ok then
-- 	return
-- end

configs.setup({
	-- ensure_installed = "all", -- one of "all" or a list of languages
  ensure_installed = { "c", "css", "dockerfile", "fish", "javascript", "jsdoc", "json", "python", "ruby", "rust", "scss", "typescript", "yaml" },
	ignore_install = { "php", "lua" }, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "css" }, -- list of language that will be disabled
	},
	autopairs = {
		enable = true,
	},
  endwise = {
    enable = true,
  },
	indent = { enable = false },
  -- textsubjects = {
  --   enable = true,
  --   prev_selection = ',',
  --   keymaps = {
  --     ['.'] = 'textsubjects-smart',
  --     [';'] = 'textsubjects-container-outer',
  --     ['i;'] = 'textsubjects-container-inner',
  --   }
  -- },
})

