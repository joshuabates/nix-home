local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

-- How do you take a list of results and feed them back into telescope
-- it would be usefull when there are too many results, that you then want to
-- filter based on something else (like file name/path)

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local M = {}

M.find_in_dir_prompt = "Find file/grep (<c-s>) in directory"

-- it's annoying to have the bqf preview open as soon as sending to the quckfix so refocus to last window instead
function send_to_qf(prompt_bufnr)
	actions.send_to_qflist(prompt_bufnr)
	vim.cmd([[ copen ]])
	vim.cmd([[ wincmd p ]])
end

function is_find_in_dir(picker)
	if picker.previewer then
		return false
	else
		return true
	end
	-- if picker.prompt_title == M.find_in_dir_prompt then
	--   return true
	-- else
	--   return false
	-- end
end

-- Implement delta as previewer for diffs
local previewers = require("telescope.previewers")
local builtin = require("telescope.builtin")
local conf = require("telescope.config")

local delta = previewers.new_termopen_previewer({
	get_command = function(entry)
		-- this is for status
		-- You can get the AM things in entry.status. So we are displaying file if entry.status == '??' or 'A '
		-- just do an if and return a different command
		if entry.status == "??" or "A " then
			return { "git", "-c", "core.pager=delta", "-c", "delta.side-by-side=false", "diff", entry.value }
		end

		-- note we can't use pipes
		-- this command is for git_commits and git_bcommits
		return { "git", "-c", "core.pager=delta", "-c", "delta.side-by-side=false", "diff", entry.value .. "^!" }
	end,
})

M.my_git_commits = function(opts)
	opts = opts or {}
	opts.previewer = delta

	builtin.git_commits(opts)
end

M.my_git_bcommits = function(opts)
	opts = opts or {}
	opts.previewer = delta

	builtin.git_bcommits(opts)
end

M.my_git_status = function(opts)
	opts = opts or {}
	opts.previewer = delta

	builtin.git_status(opts)
end

local _bad = { ".*%.csv", ".*%.sql", ".*%.lua" } -- Put all filetypes that slow you down in this array
local bad_files = function(filepath)
	for _, v in ipairs(_bad) do
		if filepath:match(v) then
			return false
		end
	end

	return true
end

local new_maker = function(filepath, bufnr, opts)
	opts = opts or {}
	if opts.use_ft_detect == nil then
		opts.use_ft_detect = true
	end
	opts.use_ft_detect = opts.use_ft_detect == false and false or bad_files(filepath)
	previewers.buffer_previewer_maker(filepath, bufnr, opts)
end

telescope.setup({
	defaults = {
		buffer_previewer_maker = new_maker,
		-- prompt_prefix = " ",
		-- selection_caret = " ",
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-q>"] = send_to_qf,
				["<esc>"] = actions.close,
				[">"] = actions.cycle_history_next,
				["<"] = actions.cycle_history_prev,
			},
			-- n = { ["<c-q>"] = trouble.open_with_trouble }
		},
		file_ignore_patterns = {
			"nodes_modules/.*",
			"vcr_cassettes/.*",
			"spec/fixtures/schemas/.*",
			".*%.snap$",
			"tags%.temp$",
		},
	},
	pickers = {
		live_grep = {
			only_sort_text = true,
		},
		find_files = {
			mappings = {
				i = {
					-- <CR> on an entry in the find in directory picker will refocus you in a new file search of that directory
					["<CR>"] = function(prompt_bufnr)
						local picker = action_state.get_current_picker(prompt_bufnr)
						if is_find_in_dir(picker) then
							local selection = require("telescope.actions.state").get_selected_entry()
							local dir = vim.fn.fnamemodify(selection.path, ":p:h")
							actions.close(prompt_bufnr)

							require("telescope.builtin").find_files({ cwd = dir })
						else
							actions.select_default(prompt_bufnr)
						end
					end,

					-- <c-s> on an entry in the find in directory picker will refocus you in a live_grep of that directory
					["<c-s>"] = function(prompt_bufnr)
						local picker = action_state.get_current_picker(prompt_bufnr)
						if is_find_in_dir(picker) then
							local selection = require("telescope.actions.state").get_selected_entry()
							local dir = vim.fn.fnamemodify(selection.path, ":p:h")
							actions.close(prompt_bufnr)

							require("telescope.builtin").live_grep({
								cwd = dir,
								prompt_title = "Grep in " .. selection.value,
							})
						end
					end,
				},
			},
		},
	},
})

telescope.load_extension("zf-native")
telescope.load_extension("termfinder")
telescope.load_extension("ui-select")
telescope.load_extension("file_browser")

return M
