return {
  { "nvim-lualine/lualine.nvim", cond = not vim.g.vscode },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  { "sainnhe/gruvbox-material" },
  { "luisiacc/gruvbox-baby" },
  { "rebelot/kanagawa.nvim" },
  { "rose-pine/neovim",          name = "rose-pine" },
  { "EdenEast/nightfox.nvim" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,

    config = function()
      require("catppuccin").setup({
        integrations = {
          blink_cmp = true,
          diffview = true,
          gitsigns = true,
          mini = {
            enabled = true,
            indentscope_color = "", -- catppuccin color (eg. `lavender`) Default: text
          },
          noice = true,
          copilot_vim = true,
          overseer = true,
          snacks = {
            enabled = true,
            indent_scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
          },
          lsp_trouble = true,
          which_key = true
          -- grug_far = false
        }
      })
    end

  },
  {
    "folke/noice.nvim",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      notify = {
        enabled = false,
      },
      messages = {
        enabled = false,
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = false,
        inc_rename = true,
      },
    },
  },
}
