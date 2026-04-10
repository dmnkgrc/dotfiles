local M = {}

function M.setup()
	require("config.fff").setup()

	vim.keymap.set("n", "ff", function()
		require("fff").find_files()
	end, { desc = "Open file picker" })
	vim.keymap.set("n", "<leader><space>", function()
		require("fff").find_files()
	end, { desc = "Find Files (Root Dir)" })
	vim.keymap.set("n", "<leader>fg", function()
		require("fff").find_in_git_root()
	end, { desc = "Find Files (git-files)" })
end

return M
