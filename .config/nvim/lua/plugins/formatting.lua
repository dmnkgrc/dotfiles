return {
	-- Formatting
	{
		"stevearc/conform.nvim",
		dependencies = { "mason.nvim" },
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = { "n", "v" },
				desc = "Format",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format" },
				-- JS/TS files are handled by Biome LSP to avoid conflicts
				-- javascript = { "biome", "prettier", stop_after_first = true },
				-- typescript = { "biome", "prettier", stop_after_first = true },
				-- javascriptreact = { "biome", "prettier", stop_after_first = true },
				-- typescriptreact = { "biome", "prettier", stop_after_first = true },
				json = { "biome", "prettier", stop_after_first = true },
				markdown = { "prettier" },
				yaml = { "prettier" },
				go = { "goimports", "gofmt" },
				rust = { "rustfmt" },
				ruby = { "rubocop" },
				sh = { "shfmt" },
			},
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.autoformat == false or vim.b[bufnr].autoformat == false then
					return
				end

				return { timeout_ms = 500, lsp_fallback = true }
			end,
			formatters = {
				ruff_format = {
					-- Check for trunk config directory
					prepend_args = function(self, ctx)
						-- Search for config files up the directory tree
						local config_path = vim.fn.findfile(".trunk/configs/.ruff.toml", ctx.dirname .. ";")
						if config_path == "" then
							config_path = vim.fn.findfile(".trunk/configs/ruff.toml", ctx.dirname .. ";")
						end
						if config_path == "" then
							config_path = vim.fn.findfile(".ruff.toml", ctx.dirname .. ";")
						end
						if config_path == "" then
							config_path = vim.fn.findfile("ruff.toml", ctx.dirname .. ";")
						end
						if config_path == "" then
							config_path = vim.fn.findfile("pyproject.toml", ctx.dirname .. ";")
						end

						if config_path ~= "" then
							return { "--config", config_path }
						end
						return {}
					end,
				},
				biome = {
					command = "biome",
					args = function(self, ctx)
						local config_path = vim.fn.findfile("biome.json", ctx.dirname .. ";")
						if config_path == "" then
							config_path = vim.fn.findfile(".trunk/configs/biome.json", ctx.dirname .. ";")
						end
						if config_path ~= "" then
							return { "format", "--stdin-file-path", "$FILENAME", "--config-path", config_path }
						end
						return { "format", "--stdin-file-path", "$FILENAME" }
					end,
				},
				prettier = {
					-- Check for trunk config directory
					prepend_args = function()
						if vim.fn.filereadable(vim.fn.getcwd() .. "/.trunk/configs/.prettierrc.yaml") == 1 then
							return { "--config", ".trunk/configs/.prettierrc.yaml" }
						elseif vim.fn.filereadable(vim.fn.getcwd() .. "/.prettierrc") == 1 then
							return { "--config", ".prettierrc" }
						elseif vim.fn.filereadable(vim.fn.getcwd() .. "/.prettierrc.json") == 1 then
							return { "--config", ".prettierrc.json" }
						elseif vim.fn.filereadable(vim.fn.getcwd() .. "/.prettierrc.yaml") == 1 then
							return { "--config", ".prettierrc.yaml" }
						end
						return {}
					end,
				},
			},
		},
	},
}

