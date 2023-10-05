return {
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      formatters_by_ft = {
        javascript = { { 'prettierd', 'prettier' } },
        typescript = { { 'prettierd', 'prettier' } },
        javascriptreact = { { 'prettierd', 'prettier' } },
        typescriptreact = { { 'prettierd', 'prettier' } },
        svelte = { { 'prettierd', 'prettier' } },
        css = { { 'prettierd', 'prettier' } },
        html = { { 'prettierd', 'prettier' } },
        json = { { 'prettierd', 'prettier' } },
        yaml = { { 'prettierd', 'prettier' } },
        markdown = { { 'prettierd', 'prettier' } },
        graphql = { { 'prettierd', 'prettier' } },
        lua = { 'stylua' },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    },
    keys = {
      {
        '<leader>lf',
        function()
          require('conform').format { lsp_fallback = true, async = false, timeout_ms = 1000 }
        end,
        mode = { 'n', 'v' },
        desc = 'Format code',
      },
    },
  },
}
