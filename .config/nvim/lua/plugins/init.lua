local M = {}

function M.load()
	vim.opt.rtp:prepend(vim.fn.expand("~/dotfiles/themes/dracula-pro"))

	require("plugins.colorscheme").setup()
	require("plugins.which_key").setup()
	require("plugins.picker").setup()
	require("plugins.completion").setup()
	require("plugins.lsp").setup()
	require("plugins.treesitter").setup()
	require("plugins.coding").setup()
	require("plugins.mini").setup()
	require("plugins.ui").setup()
	require("plugins.noice").setup()
	require("plugins.git").setup()
	require("plugins.formatting").setup()
	require("plugins.oil").setup()
	require("plugins.ufo").setup()
	require("plugins.typescript").setup()
	require("plugins.ai").setup()
	require("plugins.flash").setup()
	require("plugins.harpoon").setup()
	require("plugins.inc_rename").setup()
	require("plugins.smart_splits").setup()
	require("plugins.testing").setup()
	require("plugins.todo_comments").setup()
	require("plugins.trouble").setup()
	require("plugins.grug_far").setup()
	require("plugins.golf").setup()
	require("plugins.undotree").setup()
end

return M
