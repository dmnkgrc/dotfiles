return {
  {
    'stevearc/conform.nvim',
    opts = {
      format_on_save = {
        timeout_ms = 3000,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        fish = { 'fish_indent' },
        sh = { 'shfmt' },
        ['javascript'] = { { 'biome', 'prettier' } },
        ['javascriptreact'] = { { 'biome', 'prettier' } },
        ['typescript'] = { { 'biome', 'prettier' } },
        ['typescriptreact'] = { { 'biome', 'prettier' } },
        ['vue'] = { { 'biome', 'prettier' } },
        ['css'] = { { 'biome', 'prettier' } },
        ['scss'] = { { 'biome', 'prettier' } },
        ['less'] = { { 'biome', 'prettier' } },
        ['html'] = { { 'biome', 'prettier' } },
        ['json'] = { { 'biome', 'prettier' } },
        ['jsonc'] = { { 'biome', 'prettier' } },
        ['yaml'] = { { 'biome', 'prettier' } },
        ['markdown'] = { { 'biome', 'prettier' } },
        ['markdown.mdx'] = { { 'biome', 'prettier' } },
        ['graphql'] = { { 'biome', 'prettier' } },
        ['handlebars'] = { { 'biome', 'prettier' } },
      },
    },
  },
}
