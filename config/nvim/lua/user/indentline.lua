local status_ok, indent_blankline = pcall(require, "ibl")
if not status_ok then
	return
end

-- vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
-- vim.opt.listchars:append("eol:↴")

indent_blankline.setup({})

-- indent_blankline.setup {
--   char = "",
--   char_highlight_list = {
--       "IndentBlanklineIndent1",
--       "IndentBlanklineIndent2",
--   },
--   space_char_highlight_list = {
--       "IndentBlanklineIndent1",
--       "IndentBlanklineIndent2",
--   },
--   show_trailing_blankline_indent = false,

--   show_first_indent_level = true,
--   use_treesitter = true,
--   show_current_context = true,
--   buftype_exclude = { "terminal", "nofile" },
--   filetype_exclude = {
--     "help",
--     "packer",
--     "NvimTree",
--   },
-- }

vim.cmd([[highlight IndentBlanklineIndent1 guibg=#202020 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent2 guibg=#282828 gui=nocombine]])
