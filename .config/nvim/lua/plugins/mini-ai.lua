return {
  {
    'echasnovski/mini.ai',
    keys = {
      { 'a', mode = { 'x', 'o' } },
      { 'i', mode = { 'x', 'o' } },
    },
    dependencies = {
      'echasnovski/mini.extra',
    },
    event = 'VeryLazy',
    opts = function()
      local MiniExtra = require 'mini.extra'
      local ai = require 'mini.ai'
      return {
        custom_textobjects = {
          b = MiniExtra.gen_ai_spec.buffer(),
          F = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
        },
      }
    end,
  },
}
