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
        formatters_by_ft = {
          lua = { 'stylua' },
          fish = { 'fish_indent' },
          sh = { 'shfmt' },
          rust = { 'rustfmt' },
          ['javascript'] = { 'prettierd', 'prettier', stop_after_first = true },
          ['javascriptreact'] = { 'prettierd', 'prettier', stop_after_first = true },
          ['typescript'] = { 'prettierd', 'prettier', stop_after_first = true },
          ['typescriptreact'] = { 'prettierd', 'prettier', stop_after_first = true },
          ['vue'] = { 'prettierd', 'prettier', stop_after_first = true },
          ['css'] = { 'prettierd', 'prettier', stop_after_first = true },
          ['scss'] = { 'prettierd', 'prettier', stop_after_first = true },
          ['less'] = { 'prettierd', 'prettier', stop_after_first = true },
          ['html'] = { 'prettierd', 'prettier', stop_after_first = true },
          ['json'] = { 'prettierd', 'prettier', stop_after_first = true },
          ['jsonc'] = { 'prettierd', 'prettier', stop_after_first = true },
          ['yaml'] = { 'prettierd', 'prettier', stop_after_first = true },
          ['markdown'] = { 'prettierd', 'prettier', stop_after_first = true },
          ['markdown.mdx'] = { 'prettierd', 'prettier', stop_after_first = true },
          ['graphql'] = { 'prettierd', 'prettier', stop_after_first = true },
          ['handlebars'] = { 'prettierd', 'prettier', stop_after_first = true },
        },
      }
    end,
  },
}
