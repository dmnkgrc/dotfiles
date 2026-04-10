local M = {}

function M.setup()
	vim.g.undotree_WindowLayout = 2
	vim.g.undotree_ShortIndicators = true
	vim.g.undotree_SetFocusWhenToggle = true

	vim.keymap.set("n", "<leader>uu", "<cmd>UndotreeToggle<cr>", { desc = "Toggle Undotree" })
end

return M
