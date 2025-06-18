return {
	{
		"dmmulroy/ts-error-translator.nvim",
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
		config = true,
	},
	{
		"dmmulroy/tsc.nvim",
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
		opts = {
			run_as_monorepo = true,
		},
	},
}
