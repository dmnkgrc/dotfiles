return {
  {
    'dmmulroy/tsc.nvim',
    cmd = 'TSC',
    config = true,
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      expose_as_code_action = {
        'add_missing_imports',
        'remove_unused',
        'remove_unused_imports',
      },
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = 'all',
          includeCompletionsForModuleExports = true,
          quotePreference = 'auto',
          importModuleSpecifierPreference = 'relative',
        },
      },
    },
  },
}
