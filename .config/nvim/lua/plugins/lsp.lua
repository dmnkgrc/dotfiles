return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"SmiteshP/nvim-navic",
		},
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
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if client and client.server_capabilities.documentSymbolProvider then
						require("nvim-navic").attach(client, ev.buf)
					end

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

			local util = require("lspconfig.util")

			-- Configure vtsls
			vim.lsp.config.vtsls = {
				capabilities = capabilities,
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
				settings = {
					complete_function_calls = false,
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
							completeFunctionCalls = false,
						},
						preferences = {
							importModuleSpecifier = "non-relative",
							importModuleSpecifierEnding = "minimal",
						},
						inlayHints = {
							enumMemberValues = { enabled = false },
							functionLikeReturnTypes = { enabled = false },
							parameterNames = { enabled = "none" },
							parameterTypes = { enabled = false },
							propertyDeclarationTypes = { enabled = false },
							variableTypes = { enabled = false },
						},
					},
				},
			}

		-- Configure ESLint
		vim.lsp.config.eslint = {
			name = "eslint",
			capabilities = capabilities,
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			root_markers = {
				"eslint.config.js",
				"eslint.config.mjs",
				"eslint.config.cjs",
				"eslint.config.ts",
				"eslint.config.mts",
				"eslint.config.cts",
				".eslintrc.js",
				".eslintrc.cjs",
				".eslintrc.yaml",
				".eslintrc.yml",
				".eslintrc.json",
				".eslintrc",
				"package.json",
			},
			settings = {
				workingDirectories = { mode = "auto" },
				run = "onSave",
				useESLintClass = true,
				problems = {
					shortenToSingleLine = true,
				},
			},
		}

			-- Configure tailwindcss
			vim.lsp.config.tailwindcss = {
				capabilities = capabilities,
				filetypes = {
					"html",
					"css",
					"scss",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"vue",
					"svelte",
				},
				root_markers = { "tailwind.config.js", "tailwind.config.ts", "tailwind.config.cjs", "package.json" },
				settings = {
					tailwindCSS = {
						experimental = {
							classRegex = {
								{ "tv\\(([\\s\\S]*?)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
								{ "slots:\\s*\\{([^}]*)\\}", "[\"'`]([^\"'`]*).*?[\"'`]" },
								{ "base:\\s*[\"'`]([^\"'`]*)[\"'`]" },
								{ "extend:\\s*[\"'`]([^\"'`]*)[\"'`]" },
								{ "variants:\\s*\\{[\\s\\S]*?\\w+:\\s*\\{[\\s\\S]*?\\w+:\\s*[\"'`]([^\"'`]*)[\"'`]" },
								{ "compoundVariants:\\s*\\[[\\s\\S]*?(?:class|className):\\s*[\"'`]([^\"'`]*)[\"'`]" },
								{ "defaultVariants:\\s*\\{[\\s\\S]*?\\w+:\\s*[\"'`]([^\"'`]*)[\"'`]" },
								{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
								{ "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
								{ "clsx\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
								{ "className\\s*=\\s*[\"'`]([^\"'`]*)[\"'`]", "([^\"'`]+)" },
								{ "class\\s*=\\s*[\"'`]([^\"'`]*)[\"'`]", "([^\"'`]+)" },
								{ "(?:class|className)\\s*=\\s*{[^}]*[\"'`]([^\"'`]*)[\"'`]", "([^\"'`]+)" },
								{
									"(?:enter|leave|enter-from|enter-to|leave-from|leave-to)\\s*=\\s*[\"'`]([^\"'`]*)[\"'`]",
									"([^\"'`]+)",
								},
							},
						},
						includeLanguages = {
							typescript = "javascript",
							typescriptreact = "javascript",
						},
						validate = true,
						lint = {
							cssConflict = "warning",
							invalidApply = "error",
							invalidScreen = "error",
							invalidVariant = "error",
							invalidConfigPath = "error",
							invalidTailwindDirective = "error",
							recommendedVariantOrder = "warning",
						},
						hovers = true,
						suggestions = true,
					},
				},
			}

			vim.lsp.config.pyright = {
				capabilities = capabilities,
				filetypes = { "python" },
				root_markers = { ".trunk", "pyrightconfig.json" },
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
			}

			-- Configure lua_ls
			vim.lsp.config.lua_ls = {
				capabilities = capabilities,
				filetypes = { "lua" },
				root_markers = {
					".luarc.json",
					".luarc.jsonc",
					".luacheckrc",
					".stylua.toml",
					"stylua.toml",
					"selene.toml",
					"selene.yml",
					".git",
				},
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
			}

			vim.lsp.config.ruff = {
				capabilities = vim.tbl_deep_extend("force", capabilities, {
					general = {
						positionEncodings = { "utf-16" },
					},
				}),
				filetypes = { "python" },
				root_markers = { ".trunk", "ruff.toml", ".ruff.toml", "pyproject.toml" },
			}

			vim.lsp.config.copilot = {}

			-- Enable LSP servers
			vim.lsp.enable({ "vtsls", "eslint", "tailwindcss", "pyright", "lua_ls", "ruff", "copilot" })
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
				"eslint",
				"pyright",
				"ruff",
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
						"prettier",
						"vtsls",
						"eslint",
						"pyright",
						"ruff",
						"tailwindcss-language-server",
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
