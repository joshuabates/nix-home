require("bqf").setup({
	auto_enable = true,
	preview = {
		win_height = 999,
		win_vheight = 12,
		delay_syntax = 80,
		border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
	},
	func_map = {
		vsplit = "",
		ptogglemode = "z,",
		stoggleup = "",
	},
	filter = {
		fzf = {
			action_for = { ["ctrl-s"] = "split" },
			extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
		},
	},
})

vim.cmd("autocmd! FileType qf if (getwininfo(win_getid())[0].loclist != 1) | wincmd J | endif")

-- autocmd FileType qf if (getwininfo(win_getid())[0].loclist != 1) | wincmd J | endif
--
local fn = vim.fn

-- TODO: navigate back to quickfix line no
_G.add_current_line_to_qf = function()
	vim.cmd('caddexpr expand("%") . ":" . line(".") . ":" . getline(".")')

	local win = vim.fn.getqflist({ winid = 0 }).winid
	if win > 0 then
		return
	end

	vim.cmd("cwindow")
	vim.cmd("wincmd p")
end

function _G.qftf(info)
	local items
	local ret = {}
	if info.quickfix == 1 then
		items = fn.getqflist({ id = info.id, items = 0 }).items
	else
		items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
	end
	local limit = 31
	local fnameFmt1, fnameFmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
	local validFmt = "%s │%5d:%-3d│%s %s"
	for i = info.start_idx, info.end_idx do
		local e = items[i]
		local fname = ""
		local str
		if e.valid == 1 then
			if e.bufnr > 0 then
				fname = fn.bufname(e.bufnr)
				if fname == "" then
					fname = "[No Name]"
				else
					fname = fname:gsub("^" .. vim.env.HOME, "~")
				end
				-- char in fname may occur more than 1 width, ignore this issue in order to keep performance
				if #fname <= limit then
					fname = fnameFmt1:format(fname)
				else
					fname = fnameFmt2:format(fname:sub(1 - limit))
				end
			end
			local lnum = e.lnum > 99999 and -1 or e.lnum
			local col = e.col > 999 and -1 or e.col
			local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
			str = validFmt:format(fname, lnum, col, qtype, e.text)
		else
			str = e.text
		end
		table.insert(ret, str)
	end
	return ret
end

vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
