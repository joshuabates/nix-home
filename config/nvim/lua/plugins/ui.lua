return {
	{
		"kyazdani42/nvim-web-devicons",

		config = function()
			require("nvim-web-devicons").setup({})
		end,
	},
	{ "nvim-lualine/lualine.nvim", cond = not vim.g.vscode },
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		opts = function()
			local dashboard = require("alpha.themes.dashboard")
			dashboard.section.buttons.val = {
				dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
				dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
				dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
				dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
				dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
				dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
				dashboard.button("q", " " .. " Quit", ":qa<CR>"),
			}
			for _, button in ipairs(dashboard.section.buttons.val) do
				button.opts.hl = "AlphaButtons"
				button.opts.hl_shortcut = "AlphaShortcut"
			end
			dashboard.section.header.opts.hl = "AlphaHeader"
			dashboard.section.buttons.opts.hl = "AlphaButtons"
			dashboard.section.footer.opts.hl = "AlphaFooter"
			dashboard.opts.layout[1].val = 8
			return dashboard
		end,
		config = function(_, dashboard)
			-- close Lazy and re-open when the dashboard is ready
			if vim.o.filetype == "lazy" then
				vim.cmd.close()
				vim.api.nvim_create_autocmd("User", {
					pattern = "AlphaReady",
					callback = function()
						require("lazy").show()
					end,
				})
			end

			require("alpha").setup(dashboard.opts)

			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyVimStarted",
				callback = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end,
	},
	{
		"sainnhe/gruvbox-material",
		tag = "v1.2.4",
	},
	"lunarvim/darkplus.nvim",
	{ "rcarriga/nvim-notify", cond = not vim.g.vscode },
	{
		"folke/twilight.nvim",
		config = function()
			require("twilight").setup({
				dimming = {
					alpha = 0.5, -- amount of dimming
				},
				expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
					"function",
					"method",
					"table",
					"if_statement",
					"method_definition",
				},
			})
		end,
	},
	{
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup({
				window = {
					width = 0.5,
					backdrop = 0.5,
				},
				plugins = {
					twilight = { enabled = false },
					kitty = {
						enabled = true,
						font = "+4",
					},
				},
				on_open = function(win)
					local cmd = "kitty @ --to %s goto_layout stack"
					local socket = vim.fn.expand("$KITTY_LISTEN_ON")
					vim.fn.system(cmd:format(socket))
				end,
				on_close = function()
					local cmd = "kitty @ --to %s kitten zoom_toggle.py"
					local socket = vim.fn.expand("$KITTY_LISTEN_ON")
					vim.fn.system(cmd:format(socket, opts.font))
				end,
			})
		end,
	},
	{
		"folke/noice.nvim",
		cond = not vim.g.vscode,
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
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
			-- routes = {
			-- 	{
			-- 		filter = {
			-- 			event = "msg_show",
			-- 			any = {
			-- 				{ find = "%d+L, %d+B" },
			-- 				{ find = "; after #%d+" },
			-- 				{ find = "; before #%d+" },
			-- 			},
			-- 		},
			-- 		view = "mini",
			-- 	},
			-- },
			messages = {
				enabled = false, -- enables the Noice messages UI
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = false,
				-- inc_rename = true,
			},
		},
		-- -- stylua: ignore
		-- keys = {
		--   { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
		--   { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
		--   { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
		--   { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
		--   { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
		--   { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
		--   { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
		-- },
	},
	-- better vim.ui
	{
		"stevearc/dressing.nvim",
		lazy = true,
		cond = not vim.g.vscode,

		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},
}
