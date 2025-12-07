return {
  "Jxstxs/conceal.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  config = function()
    require("conceal").setup({
      ["typescript"] = {
        enabled = true,
        keywords = {
          ["type_annotation"] = { enabled = true, conceal = "" },
          ["type_parameters"] = { enabled = true, conceal = "" },
          ["type"] = { enabled = false }, -- Don't conceal the 'type' keyword itself
          ["interface"] = { enabled = false }, -- Don't conceal interface keyword
        },
      },
      ["typescriptreact"] = {
        enabled = true,
        keywords = {
          ["type_annotation"] = { enabled = true, conceal = "" },
          ["type_parameters"] = { enabled = true, conceal = "" },
          ["type"] = { enabled = false },
          ["interface"] = { enabled = false },
        },
      },
    })
    
    -- Create a toggle command
    vim.api.nvim_create_user_command("ConcealToggle", function()
      require("conceal").toggle()
    end, {})
  end,
}