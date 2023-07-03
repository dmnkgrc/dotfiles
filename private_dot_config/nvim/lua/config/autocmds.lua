-- Disable autoformat for lua files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "lua" },
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.cmd([[autocmd BufNewFile,BufRead Podfile,*.podspec set filetype=ruby]])
