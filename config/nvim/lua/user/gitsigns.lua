local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
	return
end

if vim.g.vscode then
	return
end

gitsigns.setup({
	signs = {
		add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
		delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		topdelete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
	},
})

-- local neogit = require('neogit')
-- neogit.setup {}

local actions = require("diffview.actions")

require("diffview").setup({})

-- function _G.ShowCommitAtLine()
--   local commit_sha = require"agitator".git_blame_commit_for_line()
--   vim.cmd("DiffviewOpen " .. commit_sha .. "^.." .. commit_sha)
-- end

-- require('vgit').setup({
--   keymaps = {},
--   live_gutter = {
--     enabled = false,
--   },
-- })

-- autocmd CursorMoved *.fugitiveblame call <SID>show_log_message()
-- autocmd User FugitiveBlob,FugitiveStageBlob call s:BlobOverrides()
-- vim.api.nvim_command("autocmd User FugitivePager nnoremap <buffer> <CR> :qq")
-- open in diffview?>
