return {
  "nvim-lua/plenary.nvim",
  {
    "folke/lazydev.nvim",
    event = { "BufReadPost", "BufNewFile" },
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.ai").setup()
      require("mini.comment").setup()
      require("mini.icons").setup()
      require("mini.surround").setup({
        -- keys = {
        --   { "cs", "sr" }
        -- }
        -- mappings = {
        --   add = 'ys',
        --   delete = 'ds',
        --   find = '',
        --   find_left = '',
        --   highlight = '',
        --   replace = 'cs',
        --   update_n_lines = '',
        --
        --   -- Add this only if you don't want to use extended mappings
        --   suffix_last = '',
        --   suffix_next = '',
        -- },
        -- search_method = 'cover_or_next',
      })
      -- TODO: this has too mny conflicts w/ existing keymaps but would be useful
      -- require("mini.operators").setup({
      --   replace = {
      --     prefix = 'gp',
      --     reindent_linewise = true,
      --   },
      -- })
      require("mini.pairs").setup()
      require("mini.indentscope").setup()

      -- TODO: treesj -> splitjoin?
      -- require("mini.splitjoin").setup()
    end,
  },

  -- "tabrielpoca/replacer.nvim",
  -- uje { "stefandtw/quickfix-reflector.vim" }

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    config = function()
      require("copilot").setup({
        -- triggered via blink
        suggestion = { enabled = false },
        panel = { enabled = false },
        copilot_model = "gpt-4o-copilot",
      })
    end,
    cond = not vim.g.vscode,
    build = ":Copilot auth",
    event = "BufReadPost",
  },
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require('nvim-highlight-colors').setup({})
    end
  },
  "vim-ruby/vim-ruby",
  {
    "folke/which-key.nvim",
    opts = {
      notify = false,
      preset = "modern",
      -- plugins = { spelling = true },
      cond = not vim.g.vscode,

      defaults = {},
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      -- wk.register(opts.defaults)
    end,
  },
  {
    'stevearc/overseer.nvim',
    opts = {},

    keys = {
      { "<leader>rt", "<cmd>OverseerRun<cr>",    desc = "Run Task" },
      { "<leader>rl", "<cmd>OverseerToggle<cr>", desc = "Tasklist" },
    }
  },
  -- use({
  --   'nvim-neotest/neotest',
  --   requires = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "antoinemadec/FixCursorHold.nvim",
  --     'olimorris/neotest-rspec',
  --   },
  -- })
  --
  -- https://github.com/vuki656/package-info.nvim
  --
  { "janko/vim-test", cond = not vim.g.vscode },
}
