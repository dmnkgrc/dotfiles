return {
	{
		"neovim/nvim-lspconfig",
		config = function(plugin, opts)
			-- Configure diagnostic signs
			local icons = require("config.icons")
			local signs = icons.diagnostics
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			-- Configure diagnostics
			vim.diagnostic.config({
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
						[vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
						[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
						[vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
					},
				},
			})

			-- Diagnostic keymaps
			local diagnostic_goto = function(next, severity)
				local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
				severity = severity and vim.diagnostic.severity[severity] or nil
				return function()
					go({ severity = severity })
				end
			end

			vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
			vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
			vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
			vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
			vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
			vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
			vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

			-- LazyVim-style LSP keymaps
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = desc })
					end

					-- Navigation
					map("gd", function()
						require("snacks").picker.lsp_definitions({ reuse_win = true })
					end, "Goto Definition")
					map("gr", function()
						require("snacks").picker.lsp_references()
					end, "References")
					map("gD", vim.lsp.buf.declaration, "Goto Declaration")
					map("gI", function()
						require("snacks").picker.lsp_implementations({ reuse_win = true })
					end, "Goto Implementation")
					map("gy", function()
						require("snacks").picker.lsp_type_definitions({ reuse_win = true })
					end, "Goto T[y]pe Definition")

					-- Hover
					map("K", vim.lsp.buf.hover, "Hover")
					map("gK", vim.lsp.buf.signature_help, "Signature Help")
					map("<c-k>", vim.lsp.buf.signature_help, "Signature Help", "i")

					-- Code action
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "v" })
					map("<leader>cA", function()
						vim.lsp.buf.code_action({
							context = {
								only = { "source" },
								diagnostics = {},
							},
						})
					end, "Source Action", { "n", "v" })

					-- Rename
					vim.keymap.set("n", "<leader>cr", function()
						return ":IncRename " .. vim.fn.expand("<cword>")
					end, { buffer = ev.buf, desc = "Rename", expr = true })
				end,
			})

			-- Get capabilities from blink.cmp
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.vtsls.setup({
				capabilities = capabilities,
				settings = {
					complete_function_calls = true,
					vtsls = {
						enableMoveToFileCodeAction = true,
						autoUseWorkspaceTsdk = true,
						experimental = {
							completion = {
								enableServerSideFuzzyMatch = true,
							},
						},
					},
					typescript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = {
							completeFunctionCalls = true,
						},
						preferences = {
							importModuleSpecifier = "relative",
							importModuleSpecifierEnding = "minimal",
						},
						inlayHints = {
							enumMemberValues = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							variableTypes = { enabled = false },
						},
					},
				},
			})
			local util = require("lspconfig.util")
			local biome_cmd = { "biome", "lsp-proxy" }
			if vim.fn.filereadable(vim.fn.getcwd() .. "/.trunk/configs/biome.json") == 1 then
				biome_cmd = { "biome", "lsp-proxy", "--config-path", ".trunk/configs" }
			end
			print(biome_cmd)
			lspconfig.biome.setup({
				root_dir = util.root_pattern(".trunk", "biome.json", "package.json"),
				cmd = biome_cmd,
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- Enable organize imports and fix all on save
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							-- Run organize imports
							vim.lsp.buf.code_action({
								apply = true,
								context = {
									only = { "source.organizeImports.biome" },
									diagnostics = {},
								},
							})
							-- Run fix all (includes removing unused imports)
							vim.lsp.buf.code_action({
								apply = true,
								context = {
									only = { "source.fixAll.biome" },
									diagnostics = {},
								},
							})
						end,
					})
				end,
			})
			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
				single_file_support = false,
				settings = {
					tailwindCSS = {
						experimental = {
							classRegex = {
								{ "tv\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
								{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
								{ "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
								{ "clsx\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
							},
						},
					},
				},
			})
			lspconfig.pyright.setup({
				capabilities = capabilities,
				single_file_support = false,
				root_dir = function(fname)
					-- First, look for .trunk directory up the tree
					local trunk_root = util.root_pattern(".trunk")(fname)
					if trunk_root then
						return trunk_root
					end
					-- If no .trunk found, look for pyrightconfig.json
					return util.root_pattern("pyrightconfig.json")(fname)
				end,
				on_new_config = function(config, root_dir)
					-- Check for pyrightconfig.json in .trunk/configs
					local trunk_config = root_dir .. "/.trunk/configs/pyrightconfig.json"
					if vim.fn.filereadable(trunk_config) == 1 then
						config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
							python = {
								pythonPath = vim.fn.exepath("python"),
								venvPath = root_dir,
							},
							pyright = {
								-- This tells pyright to use the config file at the specified path
								configurationSources = { trunk_config },
							},
						})
					end
				end,
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							autoImportCompletions = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
						},
					},
				},
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						workspace = {
							checkThirdParty = false,
						},
						completion = {
							callSnippet = "Replace",
						},
						telemetry = { enable = false },
						hint = { enable = false },
					},
				},
			})
			lspconfig.ruff.setup({
				capabilities = vim.tbl_deep_extend("force", capabilities, {
					general = {
						positionEncodings = { "utf-16" },
					},
				}),
				root_dir = function(fname)
					-- First, look for .trunk directory up the tree
					local trunk_root = util.root_pattern(".trunk")(fname)
					if trunk_root then
						return trunk_root
					end
					-- If no .trunk found, look for ruff configuration files
					return util.root_pattern("ruff.toml", ".ruff.toml", "pyproject.toml")(fname)
				end,
			})
			-- Prevent duplicate Pyright and Ruff instances
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and (client.name == "pyright" or client.name == "ruff") then
						-- Get all clients of the same type
						local clients = vim.lsp.get_clients({ name = client.name })
						if #clients > 1 then
							-- Find the client with .trunk in its root
							local trunk_client = nil
							local other_clients = {}

							for _, c in ipairs(clients) do
								if vim.fn.isdirectory(c.config.root_dir .. "/.trunk") == 1 then
									trunk_client = c
								else
									table.insert(other_clients, c)
								end
							end

							-- If we have a trunk client, stop all others
							if trunk_client then
								for _, c in ipairs(other_clients) do
									vim.lsp.stop_client(c.id, true)
								end
							else
								-- Otherwise, keep the one with shortest root_dir
								table.sort(clients, function(a, b)
									return #a.config.root_dir < #b.config.root_dir
								end)
								for i = 2, #clients do
									vim.lsp.stop_client(clients[i].id, true)
								end
							end
						end
					end
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "vtsls" then
						vim.keymap.set("n", "<leader>co", function()
							vim.lsp.buf.code_action({
								apply = true,
								context = {
									only = { "source.organizeImports.ts" },
									diagnostics = {},
								},
							})
						end, { buffer = args.buf, desc = "Organize Imports" })
						vim.keymap.set("n", "<leader>cR", function()
							vim.lsp.buf.code_action({
								apply = true,
								context = {
									only = { "source.removeUnused.ts" },
									diagnostics = {},
								},
							})
						end, { buffer = args.buf, desc = "Remove Unused Imports" })
					end
				end,
			})
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"vtsls",
				"pyright",
				"ruff",
				"biome",
				"gopls",
				"sqlls",
				"zls",
			},
		},
		dependencies = {
			"neovim/nvim-lspconfig",
			{
				"mason-org/mason.nvim",
				opts = {
					ensure_installed = {
						"stylua",
						"shfmt",
						"vtsls",
						"pyright",
						"ruff",
						"tailwindcss-language-server",
						"biome",
						"gopls",
						"rust-analyzer",
						"yaml-language-server",
						"json-lsp",
						"sqlls",
						"zls",
						"ruby-lsp",
					},
				},
			},
		},
	},
}
