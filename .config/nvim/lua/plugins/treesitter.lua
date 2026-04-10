local M = {}

--- Parser names for nvim-treesitter (rewrite; no more `nvim-treesitter.configs`).
--- See $VIMRUNTIME/pack/.../nvim-treesitter/README.md and :h nvim-treesitter-quickstart
local parsers = {
	"bash",
	"c",
	"diff",
	"html",
	"javascript",
	"typescript",
	"tsx",
	"python",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"query",
	"vim",
	"vimdoc",
}

--- Vim |filetypes| to enable core TS features (highlight/folds/indent).
local filetypes = {
	"bash",
	"sh",
	"c",
	"diff",
	"html",
	"javascript",
	"typescript",
	"typescriptreact",
	"tsx",
	"python",
	"lua",
	"markdown",
	"query",
	"vim",
	"help",
}

function M.setup()
	require("nvim-treesitter").setup({})
	require("nvim-treesitter").install(parsers)

	vim.api.nvim_create_autocmd("FileType", {
		pattern = filetypes,
		callback = function()
			pcall(vim.treesitter.start)
			pcall(function()
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo.foldmethod = "expr"
			end)
			pcall(function()
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end)
		end,
	})
end

return M
