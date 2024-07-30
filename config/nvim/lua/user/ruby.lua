vim.g["ruby_indent_assignment_style"] = "variable"
vim.g["ruby_indent_hanging_elements"] = 0

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.mjml",
  command = "setfiletype eruby"
})
