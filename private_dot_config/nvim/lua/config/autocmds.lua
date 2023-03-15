vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
  -- enable wrap mode for json files only
  command = "EslintFixAll",
})
