return {
  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
    opts = {
      mappings = {
        ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\`].', register = { cr = false } },
      },
    },
  },
  -- Fast and feature-rich surround actions. For text that includes
  -- surrounding characters like brackets or quotes, this allows you
  -- to select the text inside, change or modify the surrounding characters,
  -- and more.
  {
    'echasnovski/mini.surround',
    opts = {
      mappings = {
        add = 'gsa', -- Add surrounding in Normal and Visual modes
        delete = 'gsd', -- Delete surrounding
        find = 'gsf', -- Find surrounding (to the right)
        find_left = 'gsF', -- Find surrounding (to the left)
        highlight = 'gsh', -- Highlight surrounding
        replace = 'gsr', -- Replace surrounding
        update_n_lines = 'gsn', -- Update `n_lines`
      },
    },
  },

  -- comments
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },

  -- Better text-objects
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
  {
    'monaqa/dial.nvim',
    keys = {
      {
        '<C-a>',
        function()
          require('dial.map').manipulate('increment', 'normal')
        end,
        'Increment',
      },
      {
        '<C-x>',
        function()
          require('dial.map').manipulate('decrement', 'normal')
        end,
        'Decrement',
      },
      {
        'g<C-a>',
        function()
          require('dial.map').manipulate('increment', 'gnormal')
        end,
        'Increment g',
      },
      {
        'g<C-x>',
        function()
          require('dial.map').manipulate('decrement', 'gnormal')
        end,
        'Decrement g',
      },
      {
        '<C-a>',
        function()
          require('dial.map').manipulate('increment', 'visual')
        end,
        mode = 'v',
        desc = 'Increment visual selection',
      },
      {
        '<C-x>',
        function()
          require('dial.map').manipulate('decrement', 'visual')
        end,
        mode = 'v',
        desc = 'Decrement visual selection',
      },
      {
        'g<C-a>',
        function()
          require('dial.map').manipulate('increment', 'gvisual')
        end,
        mode = 'v',
        desc = 'Increment visual selection g',
      },
      {
        'g<C-x>',
        function()
          require('dial.map').manipulate('decrement', 'gvisual')
        end,
        mode = 'v',
        desc = 'Decrement visual selection g',
      },
    },
  },
  {
    'smjonas/inc-rename.nvim',
    config = true,
    keys = {
      {
        '<leader>rn',
        '<cmd>IncRename<cr>',
        desc = 'Rename',
      },
    },
  },
  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    branch = 'v0.6',
    opts = {
      tabout = {
        enable = true,
        hopout = true,
      },
    },
  },
  {
    'otavioschwanck/arrow.nvim',
    event = 'VeryLazy',
    opts = {
      show_icons = true,
      leader_key = ';',
      buffer_leader_key = 'm',
    },
  },
}
