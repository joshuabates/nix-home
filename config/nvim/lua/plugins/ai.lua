if vim.g.vscode then
  return {}
end

return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "MCPHub",
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup()
    end,
  },
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
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      provider = "copilot",
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "zbirenbaum/copilot.lua",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
          },
        },
      },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
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
  }

}
