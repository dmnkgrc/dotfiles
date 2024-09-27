return {
  {
    'dmmulroy/tsc.nvim',
    cmd = 'TSC',
    config = true,
  },
  {
    'pmizio/typescript-tools.nvim',
    enabled = false,
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      expose_as_code_action = 'all',
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = 'all',
          includeCompletionsForModuleExports = true,
          quotePreference = 'auto',
          importModuleSpecifierPreference = 'non-relative',
        },
      },
    },
  },
}
