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
      require("mini.comment").setup({
        hooks = {
          post = function()
            if vim.fn.mode() == "n" then
              vim.cmd('normal! j')
            end
          end,
        }
      })
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
      Snacks.toggle({
        name = "Github Copilot",
        get = function()
          return vim.b.copilot_enabled;
        end,
        set = function(state)
          local suggestions = require("copilot.suggestion")
          require("copilot.client").use_client(function()
            suggestions.toggle_auto_trigger()
          end)

          if state then
            vim.b.copilot_enabled = true
            -- vim.b.copilot_suggestion_auto_trigger = false
          else
            -- vim.b.copilot_suggestion_auto_trigger = true
            vim.b.copilot_enabled = false
          end
        end,
      }):map("<leader><Tab>")

      require("copilot").setup({
        -- triggered via blink
        suggestion = {
          enabled = true,
          auto_trigger = false,
          hide_during_completion = true,
          keymap = {
            accept = "<Tab>",
            accept_word = "<Right>",
            accept_line = false,
            next = "<Down>",
            prev = "<Up>",
            dismiss = "<C-]>",
          },
        },
        panel = { enabled = false },
      })
    end,
    cond = not vim.g.vscode,
    build = ":Copilot auth",
    event = "BufReadPost",
    keys = {
      { "<leader><Tab>", "<cmd>Copilot suggestion toggle_auto_trigger<cr>", desc = "Toggle Copilot" },
    }
  },
  {
    "coder/claudecode.nvim",
    config = true,
    keys = {
      { "<leader>a",  nil,                              desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",              desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree" },
      },
    },
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
