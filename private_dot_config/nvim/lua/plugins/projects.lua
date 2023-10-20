return {
  {
    'ahmedkhalf/project.nvim',
    config = true,
    name = 'project_nvim',
    opts = {
      detection_methods = { 'pattern', 'lsp' },
      patterns = { '!>packages', '.git', 'Makefile', 'package.json' },
    },
  },
}
