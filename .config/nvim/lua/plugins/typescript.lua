local M = {}

function M.setup()
	require("ts-error-translator").setup()
	require("tsc").setup({
		run_as_monorepo = true,
		flags = "--build --noEmit",
	})
end

return M
