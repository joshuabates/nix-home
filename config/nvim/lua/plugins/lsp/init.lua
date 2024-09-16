if vim.g.vscode then
	return
end

local utils = require("user.utils")

local function on_attach(on_attach)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, buffer)
		end,
	})
end

local function setup_lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(bufnr, "n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap(bufnr, "n", "gr", "<cmd>lua require('telescope.builtin').lsp_references({ show_line = false })<CR>", opts)
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
end


return {
	"ray-x/lsp_signature.nvim",
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
		config = function()
			require("typescript-tools").setup({
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
          vim.lsp.inlay_hint.enable(true)
				end,
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
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
			{ "folke/neodev.nvim", opts = {} },
			"hrsh7th/cmp-nvim-lsp",
		},
		opts = {
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
					-- prefix = "icons",
				},
				severity_sort = true,
			},
			inlay_hints = {
				enabled = false,
			},
			capabilities = {},
			autoformat = true,
			format_notify = false,
			format = {
				formatting_options = nil,
				timeout_ms = nil,
				filter = function(client)
					return client.name ~= "solargraph"
				end,
			},
			servers = {
				jsonls = {
          cmd = utils.maybe_yarn_cmd("vscode-json-language-server", { "--stdio" }),
        },
				yamlls = {
          cmd = utils.maybe_yarn_cmd("yaml-language-server", { "--stdio" }),
        },
				cssls = {
          cmd = utils.maybe_yarn_cmd("vscode-css-language-server", { "--stdio" }),
        },
        stylelint_lsp = {
          cmd = utils.maybe_yarn_cmd("stylelint-lsp", { "--stdio" }),
          filetypes = { "css", "scss", "less", "sass" },
        },
        cssmodules_ls = {
          cmd = utils.maybe_yarn_cmd("cssmodules-language-server"),
        },
				standardrb = {
          cmd = utils.maybe_gem_cmd("standard", { "--lsp" }),
        },
				ruby_lsp = {
          cmd = utils.maybe_gem_cmd("ruby-lsp"),
					init_options = {
						formatter = false,
					},
					settings = {
            ruby_lsp = {
							autoformat = false,
							completion = true,
							diagnostics = false,
							folding = false,
							references = true,
							rename = true,
							-- symbols = false,
            }
          },
				},
				solargraph = {
          enable = false,
          cmd = utils.maybe_gem_cmd("solargraph", { "stdio" }),
					-- See: https://medium.com/@cristianvg/neovim-lsp-your-rbenv-gemset-and-solargraph-8896cb3df453
					-- root_dir = require("lspconfig").util.root_pattern("Gemfile", ".git", "."),
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
        lua_ls = {
          on_init = function(client)
            local path = client.workspace_folders[1].name
            if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
              return
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                version = 'LuaJIT'
              },
              -- Make the server aware of Neovim runtime files
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME
                  -- Depending on the usage, you might want to add additional paths here.
                  -- "${3rd}/luv/library"
                  -- "${3rd}/busted/library",
                }
              }
            })
          end,
        }

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

			-- if opts.inlay_hints.enabled and vim.lsp.buf.inlay_hint then
			-- 	on_attach(function(client, buffer)
			-- 		if client.server_capabilities.inlayHintProvider then
			-- 			vim.lsp.buf.inlay_hint(buffer, true)
			-- 		end
			-- 	end)
			-- end

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

			for server, server_opts in pairs(servers) do
        setup(server)
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
}
