if not vim.g.vscode then
  return {
    {
      "lewis6991/gitsigns.nvim",
      event = "VeryLazy",
    },
    {
      "ruifm/gitlinker.nvim",
      event = "InsertEnter",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("gitlinker").setup()
      end,
    },

    {
      "sindrets/diffview.nvim",
      event = "InsertEnter",
      requires = "nvim-lua/plenary.nvim"
    },

    "tpope/vim-fugitive",
  }
end
