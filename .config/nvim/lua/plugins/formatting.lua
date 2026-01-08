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
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },
				json = { "prettierd" },
				jsonc = { "prettierd" },
				markdown = { "prettierd" },
				css = { "prettierd" },
				yaml = { "prettierd" },
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
							return { "--config", vim.fn.fnamemodify(config_path, ":p") }
						end
						return {}
					end,
				},
				prettier = {
					cwd = function()
						require("conform.util").root_file({ ".trunk", "pnpm-workspace.yaml" })
					end,
					prepend_args = function(self, ctx)
						local trunk_dir = vim.fn.finddir(".trunk", ctx.dirname .. ";")
						if trunk_dir ~= "" then
							local trunk_root = vim.fs.dirname(trunk_dir)
							local trunk_configs = {
								trunk_root .. "/.trunk/configs/.prettierrc.json",
								trunk_root .. "/.trunk/configs/.prettierrc.yaml",
							}
							for _, config_path in ipairs(trunk_configs) do
								if vim.fn.filereadable(config_path) == 1 then
									return { "--config", config_path }
								end
							end
						end
						return {}
					end,
				},
				prettierd = {
					cwd = function()
						require("conform.util").root_file({ ".trunk", "pnpm-workspace.yaml" })
					end,
					env = function(self, ctx)
						local trunk_dir = vim.fn.finddir(".trunk", ctx.dirname .. ";")
						if trunk_dir ~= "" then
							local trunk_root = vim.fs.dirname(trunk_dir)
							local trunk_configs = {
								trunk_root .. "/.trunk/configs/.prettierrc.json",
								trunk_root .. "/.trunk/configs/.prettierrc.yaml",
							}
							for _, config_path in ipairs(trunk_configs) do
								if vim.fn.filereadable(config_path) == 1 then
									return { PRETTIERD_DEFAULT_CONFIG = config_path }
								end
							end
						end
						return {}
					end,
				},
			},
		},
	},
}
