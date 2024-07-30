if vim.g.vscode then
	return
end

local wk = require("which-key")

wk.register({
	["<leader>w"] = {
		w = "Save File",
		e = {
			function()
				require("neo-tree.command").execute({ toggle = true })
			end,
			"Toggle Explorer",
		},
	},
})

return {
	{
		"folke/edgy.nvim",
		enabled = false,
		event = "VeryLazy",
		keys = {
			{
				"<leader>ue",
				function()
					require("edgy").toggle()
				end,
				desc = "Edgy Toggle",
			},
      -- stylua: ignore
      { "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
		},
		opts = function()
			local opts = {
				bottom = {
					{
						ft = "toggleterm",
						size = { height = 0.4 },
						filter = function(buf, win)
							return vim.api.nvim_win_get_config(win).relative == ""
						end,
					},
					{
						ft = "noice",
						size = { height = 0.4 },
						filter = function(buf, win)
							return vim.api.nvim_win_get_config(win).relative == ""
						end,
					},
					{
						ft = "lazyterm",
						title = "LazyTerm",
						size = { height = 0.4 },
						filter = function(buf)
							return not vim.b[buf].lazyterm_cmd
						end,
					},
					"Trouble",
					{ ft = "qf", title = "QuickFix" },
					{
						ft = "help",
						size = { height = 20 },
						-- don't open help files in edgy that we're editing
						filter = function(buf)
							return vim.bo[buf].buftype == "help"
						end,
					},
					{ ft = "spectre_panel", size = { height = 0.4 } },
					{ title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
				},
				left = {
					{
						title = "Neo-Tree",
						ft = "neo-tree",
						filter = function(buf)
							return vim.b[buf].neo_tree_source == "filesystem"
						end,
						pinned = true,
						open = function()
							vim.api.nvim_input("<esc><space>e")
						end,
						size = { height = 0.5 },
					},
					{ title = "Neotest Summary", ft = "neotest-summary" },
					{
						title = "Neo-Tree Git",
						ft = "neo-tree",
						filter = function(buf)
							return vim.b[buf].neo_tree_source == "git_status"
						end,
						pinned = true,
						open = "Neotree position=right git_status",
					},
					{
						title = "Neo-Tree Buffers",
						ft = "neo-tree",
						filter = function(buf)
							return vim.b[buf].neo_tree_source == "buffers"
						end,
						pinned = true,
						open = "Neotree position=top buffers",
					},
					"neo-tree",
				},
				keys = {
					-- increase width
					["<c-Right>"] = function(win)
						win:resize("width", 2)
					end,
					-- decrease width
					["<c-Left>"] = function(win)
						win:resize("width", -2)
					end,
					-- increase height
					["<c-Up>"] = function(win)
						win:resize("height", 2)
					end,
					-- decrease height
					["<c-Down>"] = function(win)
						win:resize("height", -2)
					end,
				},
			}
			-- local Util = require("lazyvim.util")
			-- if Util.has("symbols-outline.nvim") then
			-- 	table.insert(opts.left, {
			-- 		title = "Outline",
			-- 		ft = "Outline",
			-- 		pinned = true,
			-- 		open = "SymbolsOutline",
			-- 	})
			-- end
			return opts
		end,
	},
	-- file explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		deactivate = function()
			vim.cmd([[Neotree close]])
		end,
		init = function()
			vim.g.neo_tree_remove_legacy_commands = 1
			if vim.fn.argc() == 1 then
				local stat = vim.loop.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("neo-tree")
				end
			end
		end,
		opts = {
			sources = { "filesystem", "buffers", "git_status", "document_symbols" },
			open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline", "edgy" },
			filesystem = {
				bind_to_cwd = false,
				follow_current_file = true,
				use_libuv_file_watcher = true,
			},
			window = {
				mappings = {
					["<space>"] = "none",
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				icon = {
					folder_empty = "󰜌",
					folder_empty_open = "󰜌",
				},
				git_status = {
					symbols = {
						renamed = "󰁕",
						unstaged = "󰄱",
					},
				},
			},
		},
		config = function(_, opts)
			require("neo-tree").setup(opts)

			vim.api.nvim_create_autocmd("TermClose", {
				pattern = "*lazygit",
				callback = function()
					if package.loaded["neo-tree.sources.git_status"] then
						require("neo-tree.sources.git_status").refresh()
					end
				end,
			})
		end,
	},
	"akinsho/toggleterm.nvim",
	"knubie/vim-kitty-navigator",
	-- "kevinhwang91/nvim-bqf",
  {
  "folke/trouble.nvim",
    branch = "dev", -- IMPORTANT!
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
    opts = {}, -- for default options, refer to the configuration section for custom setup.
  }
}
