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
				javascript = { "oxfmt" },
				typescript = { "oxfmt" },
				javascriptreact = { "oxfmt" },
				typescriptreact = { "oxfmt" },
				json = { "oxfmt" },
				jsonc = { "oxfmt" },
				markdown = { "oxfmt" },
				css = { "oxfmt" },
				yaml = { "oxfmt" },
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
				oxfmt = {
					command = "oxfmt",
					args = { "--stdin-filepath", "$FILENAME" },
					stdin = true,
				},
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
			},
		},
	},
}
