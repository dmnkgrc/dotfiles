return {
  {
    'stevearc/conform.nvim',
    config = function()
      local conform = require 'conform'
      conform.setup {
        format_on_save = {
          timeout_ms = 3000,
          lsp_fallback = true,
        },
        formatters = {
          biome_or_prettier = {
            command = 'biome_or_prettier',
            args = { '--path', '$FILENAME' },
            stdin = true,

            cwd = require('conform.util').root_file { 'package.json' },
          },
        },
        formatters_by_ft = {
          lua = { 'stylua' },
          fish = { 'fish_indent' },
          sh = { 'shfmt' },
          rust = { 'rustfmt' },
          ['javascript'] = { { 'biome_or_prettier' } },
          ['javascriptreact'] = { { 'biome_or_prettier' } },
          ['typescript'] = { { 'biome_or_prettier' } },
          ['typescriptreact'] = { { 'biome_or_prettier' } },
          ['vue'] = { { 'biome_or_prettier' } },
          ['css'] = { { 'biome_or_prettier' } },
          ['scss'] = { { 'biome_or_prettier' } },
          ['less'] = { { 'biome_or_prettier' } },
          ['html'] = { { 'biome_or_prettier' } },
          ['json'] = { { 'biome_or_prettier' } },
          ['jsonc'] = { { 'biome_or_prettier' } },
          ['yaml'] = { { 'biome_or_prettier' } },
          ['markdown'] = { { 'biome_or_prettier' } },
          ['markdown.mdx'] = { { 'biome_or_prettier' } },
          ['graphql'] = { { 'biome_or_prettier' } },
          ['handlebars'] = { { 'biome_or_prettier' } },
        },
      }
    end,
  },
}
