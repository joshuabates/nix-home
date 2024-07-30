if not vim.g.vscode then
	return {
		{
			"L3MON4D3/LuaSnip",
			-- follow latest release.
			version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			-- install jsregexp (optional!).
			build = "make install_jsregexp",
		},
		-- {
		-- 	"L3MON4D3/LuaSnip",
		-- 	-- follow latest release.
		-- 	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- 	-- install jsregexp (optional!).
		-- 	build = "make install_jsregexp",
		-- },
		-- "rafamadriz/friendly-snippets", -- a bunch of snippets to use
		{
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-nvim-lua",
				"saadparwaiz1/cmp_luasnip",
			},
			opts = function(_, opts)
				local has_words_before = function()
					unpack = unpack or table.unpack
					local line, col = unpack(vim.api.nvim_win_get_cursor(0))
					return col ~= 0
						and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
				end

				local cmp = require("cmp")
        local luasnip = require("luasnip")
				if not opts.mapping then
					opts.mapping = {}
				end

				opts.mapping = vim.tbl_extend("force", opts.mapping, {
					["<CR>"] = vim.NIL,

					["<Tab>"] = cmp.mapping(function(fallback)
						if require("copilot.suggestion").is_visible() then
							require("copilot.suggestion").accept_line()
            elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
            elseif has_words_before() then
								cmp.complete()
            else
								fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				})
				opts.preselect = cmp.PreselectMode.None
			end,
		},
	}
end
