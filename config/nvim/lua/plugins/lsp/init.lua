if vim.g.vscode then
	return
end

local function on_attach(on_attach)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, buffer)
		end,
	})
end

-- function M.diagnostic_goto(next, severity)
--   local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
--   severity = severity and vim.diagnostic.severity[severity] or nil
--   return function()
--     go({ severity = severity })
--   end
-- end
--
-- return M

local function setup_lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(bufnr, "n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	keymap(bufnr, "n", "gx", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

	keymap(bufnr, "n", "<leader>ld", "<cmd>lua _G.toggle_diagnostics()<CR>", opts)
	keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
	keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
	keymap(bufnr, "n", "<leader>lI", "<cmd>LspInstallInfo<cr>", opts)
	keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  keymap(bufnr, "v", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
	keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
	keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
	keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	--   { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
	--   { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
	--   { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition", has = "definition" },
	--   { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
	--   { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
	--   { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
	--   { "gy", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto T[y]pe Definition" },
	--   { "K", vim.lsp.buf.hover, desc = "Hover" },
	--   { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
	--   { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
	--   { "]d", M.diagnostic_goto(true), desc = "Next Diagnostic" },
	--   { "[d", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
	--   { "]e", M.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
	--   { "[e", M.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
	--   { "]w", M.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
	--   { "[w", M.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
	--   { "<leader>cf", format, desc = "Format Document", has = "documentFormatting" },
	--   { "<leader>cf", format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
	--   { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
	--   {
	--     "<leader>cA",
	--     function()
	--       vim.lsp.buf.code_action({
	--         context = {
	--           only = {
	--             "source",
	--           },
	--           diagnostics = {},
	--         },
	--       })
	--     end,
	--     desc = "Source Action",
	--     has = "codeAction",
	--   }
	-- }
	-- if require("lazyvim.util").has("inc-rename.nvim") then
	--   M._keys[#M._keys + 1] = {
	--     "<leader>cr",
	--     function()
	--       local inc_rename = require("inc_rename")
	--       return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
	--     end,
	--     expr = true,
	--     desc = "Rename",
	--     has = "rename",
	--   }
	-- else
	--   M._keys[#M._keys + 1] = { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" }
	-- end
	-- nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
	-- nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
	-- nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
end

return {
	"ray-x/lsp_signature.nvim",
	-- "jose-elias-alvarez/typescript.nvim",
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
		config = function()
			require("typescript-tools").setup({
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
					if vim.fn.has("nvim-0.10") then
						-- Enable inlay hints
						vim.lsp.inlay_hint.enable(bufnr, true)
					end
				end,
				-- handlers = handlers,
				settings = {
					separate_diagnostic_server = true,
					code_lens = "off",
					tsserver_file_preferences = {
						includeInlayParameterNameHints = "all",
						includeCompletionsForModuleExports = true,
						quotePreference = "auto",
					},
				},
			})
		end,
	},
	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
			{ "folke/neodev.nvim", opts = {} },
			"mason.nvim",
			{ "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = true } },
			"hrsh7th/cmp-nvim-lsp",
		},
		---@class PluginLspOpts
		opts = {
			-- options for vim.diagnostic.config()
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
					-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
					-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
					-- prefix = "icons",
				},
				severity_sort = true,
			},
			-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the inlay hints.
			inlay_hints = {
				enabled = false,
			},
			-- add any global capabilities here
			capabilities = {},
			-- Automatically format on save
			autoformat = true,
			-- Enable this to show formatters used in a notification
			-- Useful for debugging formatter issues
			format_notify = false,
			-- options for vim.lsp.buf.format
			-- `bufnr` and `filter` is handled by the LazyVim formatter,
			-- but can be also overridden when specified
			format = {
				formatting_options = nil,
				timeout_ms = nil,
				filter = function(client)
					return client.name ~= "solargraph"
				end,
			},
			-- LSP Server Settings
			---@type lspconfig.options
			-- turn off formatting
			--
			--
			servers = {
				jsonls = {},
				ruby_ls = {
					mason = false,
					-- cmd = { "bundle", "exec", "ruby-lsp" },
					-- cmd = { "bundle", "exec", "ruby-lsp" },
					cmd = { os.getenv("HOME") .. "/.asdf/shims/ruby-lsp" },
					init_options = {
						formatter = false,
					},
					settings = {
            ruby_ls = {
							autoformat = false,
							completion = true,
							diagnostics = false,
							folding = false,
							references = false,
							rename = true,
							symbols = false,
            }
          },
				},
        stylelint_lsp = {},
        cssmodules_ls = {},
				solargraph = {
					mason = false,
					-- See: https://medium.com/@cristianvg/neovim-lsp-your-rbenv-gemset-and-solargraph-8896cb3df453
					cmd = { os.getenv("HOME") .. "/.asdf/shims/solargraph", "stdio" },
					root_dir = require("lspconfig").util.root_pattern("Gemfile", ".git", "."),
					capabilities = { documentFormattingProvider = false },
					settings = {
						solargraph = {
							autoformat = false,
							completion = false,
							diagnostics = false,
							folding = false,
							references = true,
							rename = false,
							symbols = false,
						},
					},
				},
				cssls = {},
				standardrb = {},
				-- lua_ls = {
				-- 	settings = {
				-- 		Lua = {
				-- 			workspace = {
				-- 				checkThirdParty = false,
				-- 			},
				-- 			completion = {
				-- 				callSnippet = "Replace",
				-- 			},
				-- 		},
				-- 	},
				-- },
			},
			setup = {
				-- tsserver = function(_, opts)
				--   require("typescript").setup({ server = opts })
				--   return true
				-- end,
			},
		},

		---@param opts PluginLspOpts
		config = function(_, opts)
			on_attach(function(client, buffer)
				setup_lsp_keymaps(buffer)
				vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
					callback = function()
						local lint_status, lint = pcall(require, "lint")
						if lint_status then
							lint.try_lint()
						end
					end,
				})
			end)

			if opts.inlay_hints.enabled and vim.lsp.buf.inlay_hint then
				on_attach(function(client, buffer)
					if client.server_capabilities.inlayHintProvider then
						vim.lsp.buf.inlay_hint(buffer, true)
					end
				end)
			end

			-- if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
			--   opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
			--     or function(diagnostic)
			--       local icons = require("lazyvim.config").icons.diagnostics
			--       for d, icon in pairs(icons) do
			--         if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
			--           return icon
			--         end
			--       end
			--     end
			-- end

			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			local servers = opts.servers
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				require("cmp_nvim_lsp").default_capabilities(),
				opts.capabilities or {}
			)

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			-- get all the servers that are available thourgh mason-lspconfig
			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local all_mslp_servers = {}
			if have_mason then
				all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
			end

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
					if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
						setup(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end

			if have_mason then
				mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
			end
		end,
	},
	-- {
	-- 	"pmizio/typescript-tools.nvim",
	-- 	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	-- 	opts = {
	-- 		on_attach = function(client)
	-- 			client.server_capabilities.documentFormattingProvider = false
	-- 			client.server_capabilities.documentRangeFormattingProvider = false
	-- 		end,
	-- 	},
	-- },
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				javascript = {
					"eslint_d",
				},
				typescript = {
					"eslint_d",
				},
				javascriptreact = {
					"eslint_d",
				},
				typescriptreact = {
					"eslint_d",
				},
			}
		end,
	},

	{
		"stevearc/conform.nvim",
		ft = { "lua", "vue", "typescript", "typescriptreact", "javascript", "json", "jsonc", "ruby" },
		opts = {
			formatters_by_ft = {
				-- lua = { "stylua" },
				vue = { "eslint_d" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				javascript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				json = { "prettier" },
				jsonc = { "prettier" },
				ruby = { "standardrb" },
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
			})
		end,
	},

	{

		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
				-- "tsserver",
				-- "flake8",
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
}
