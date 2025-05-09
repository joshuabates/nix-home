return {
  { "sainnhe/gruvbox-material" },
  { "rebelot/kanagawa.nvim" },
  { "EdenEast/nightfox.nvim" },
  { "rose-pine/neovim",          name = "rose-pine" },
  { "folke/tokyonight.nvim",     lazy = false,           priority = 1000 },
  { "catppuccin/nvim",           name = "catppuccin",    priority = 1000 },

  { "nvim-lualine/lualine.nvim", cond = not vim.g.vscode },
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
