return {
	"nvim-treesitter/nvim-treesitter",
	-- 	"nvim-treesitter/playground",
	"RRethy/nvim-treesitter-textsubjects",
	"JoosepAlviste/nvim-ts-context-commentstring",
  {
    'ckolkey/ts-node-action',
     dependencies = { 'nvim-treesitter' },
     opts = {},
     keys = {
      { "gC", function() require('ts-node-action.actions').cycle_case() end, desc = "Cycle Case" },
      { "gt", function() require('ts-node-action.actions').toggle_boolean() end, desc = "Toggle BOOL" },
     }
   },
	"RRethy/nvim-treesitter-endwise",
	-- 	-- split/join via treesitter <leader-m>toggle
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter" },
		keys = {
			{ "gj", ":TSJToggle<cr>", desc = "Split/Join" },
		},
		config = function()
			require("treesj").setup({--[[ your config ]]
				use_default_keymaps = false,
			})
		end,
	},
	{
		"mizlan/iswap.nvim",
		keys = {
			{ "gs", ":ISwapNodeWith<cr>", desc = "Swap node" },
			-- { "<leader>is", ":ISwap<cr>", desc = "Swap many arguments" },
		},
		opts = {},
	},
}
