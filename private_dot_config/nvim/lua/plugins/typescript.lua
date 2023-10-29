return {
  {
    "dmmulroy/tsc.nvim",
    name = "tsc",
    cmd = "TSC",
    lazy = true,
    config = true,
    -- opts = {
    --   flags = {
    --     build = true,
    --   },
    -- },
  },
  -- {
  --   'pmizio/typescript-tools.nvim',
  --   event = { 'BufReadPre', 'BufNewFile' },
  --   dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  --   opts = {
  --     settings = {
  --       tsserver_file_preferences = {
  --         quotePreference = 'single',
  --         includeCompletionsForImportStatements = true,
  --         includeCompletionsForModuleExports = true,
  --         importModuleSpecifierEnding = 'auto',
  --         importModuleSpecifierPreference = 'non-relative',
  --       },
  --       tsserver_format_options = {
  --         allowRenameOfImportPath = true,
  --       },
  --       expose_as_code_action = { 'add_missing_imports', 'remove_unused' },
  --       complete_function_calls = true,
  --     },
  --   },
  -- },
}
