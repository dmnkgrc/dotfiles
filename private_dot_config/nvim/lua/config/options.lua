-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.api.nvim_set_hl(0, "CmpItemKindTabNine", { fg = "#6CC644" })
vim.api.nvim_set_hl(0, "CmpItemKindCodeium", { fg = "#a6e3a1" })
vim.opt.laststatus = 3

vim.opt.completeopt = { "menu", "menuone", "noselect", "preview" }

vim.filetype.add({
  extension = {
    postcss = "css",
  },
})
