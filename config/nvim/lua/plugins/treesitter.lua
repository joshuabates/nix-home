return {
  "nvim-treesitter/nvim-treesitter",
  -- 	"nvim-treesitter/playground",
  "JoosepAlviste/nvim-ts-context-commentstring",
  "RRethy/nvim-treesitter-textsubjects",
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "VeryLazy",
  },
  {
    'ckolkey/ts-node-action',
    dependencies = { 'nvim-treesitter' },
    event = "VeryLazy",
    opts = {},
    keys = {
      { "gC", function() require('ts-node-action.actions').cycle_case() end,     desc = "Cycle Case" },
      { "gt", function() require('ts-node-action.actions').toggle_boolean() end, desc = "Toggle BOOL" },
    }
  },
  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    opts = {},
  },
  {
    "RRethy/nvim-treesitter-endwise",
    event = "VeryLazy",
  },
  -- 	-- split/join via treesitter <leader-m>toggle
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter" },
    event = "VeryLazy",
    keys = {
      { "gj", ":TSJToggle<cr>", desc = "Split/Join" },
    },
    config = function()
      require("treesj").setup({ --[[ your config ]]
        use_default_keymaps = false,
      })
    end,
  },
  {
    "mizlan/iswap.nvim",
    event = "VeryLazy",
    keys = {
      { "gs", ":ISwapNodeWith<cr>", desc = "Swap node" },
      -- { "<leader>is", ":ISwap<cr>", desc = "Swap many arguments" },
    },
    opts = {},
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      show_success_message = true,
    },
    keys = { {
      "<leader>lR",
      function()
        require('refactoring').select_refactor()
      end,
      mode = "v",
      desc = "Refactor",
    } },
    config = function(_, opts)
      require("refactoring").setup(opts)
    end
  },
  {
    'abecodes/tabout.nvim',
    lazy = false,
    config = function()
      require('tabout').setup {
        completion = false, -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = '`', close = '`' },
          { open = '(', close = ')' },
          { open = '[', close = ']' },
          { open = '{', close = '}' },
          { open = '<', close = '>' }
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
      }
    end,
    dependencies = { -- These are optional
      "nvim-treesitter/nvim-treesitter",
    },
    opt = true,              -- Set this to true if the plugin is optional
    event = 'InsertCharPre', -- Set the event to 'InsertCharPre' for better compatibility
    priority = 1000,
  },
}
