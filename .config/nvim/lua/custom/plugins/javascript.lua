return {
  {
    'dmmulroy/tsc.nvim',
    config = true,
  },
  {
    'toppair/peek.nvim',
    build = 'deno task --quiet build:fast',
    keys = {
      {
        '<leader>op',
        function()
          local peek = require 'peek'
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
        desc = 'Peek (Markdown Preview)',
      },
    },
  },
  {
    'MaximilianLloyd/tw-values.nvim',
    keys = {
      { '<leader>sv', '<cmd>TWValues<cr>', desc = 'Show tailwind CSS values' },
    },
    opts = {
      border = 'rounded', -- Valid window border style,
      show_unknown_classes = true, -- Shows the unknown classes popup
    },
  },
}
