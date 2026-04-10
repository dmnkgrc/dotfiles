local M = {}

function M.setup()
	require("gitsigns").setup({
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
	})

	require("diffview").setup()

	vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "DiffView" })
	vim.keymap.set("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git status" })
end

return M
