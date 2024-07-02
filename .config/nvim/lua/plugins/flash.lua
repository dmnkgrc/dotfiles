return {
  {
    'smoka7/hop.nvim',
    event = 'VeryLazy',
    version = '*',
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require('hop').setup { keys = 'etovxqpdygfblzhckisuran' }
      local hop = require 'hop'
      local directions = require('hop.hint').HintDirection
      vim.keymap.set('', 'f', function()
        hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = false }
      end, { remap = true })
      vim.keymap.set('', 'F', function()
        hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = false }
      end, { remap = true })
      vim.keymap.set('', 't', function()
        hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = false, hint_offset = -1 }
      end, { remap = true })
      vim.keymap.set('', 'T', function()
        hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = false, hint_offset = 1 }
      end, { remap = true })
    end,
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, '<cmd>HopWord<cr>', desc = 'Hop word' },
      { 'S', mode = { 'n', 'x', 'o' }, '<cmd>HopNodes<cr>', desc = 'Hop Treesitter' },
      { '<leader>hc', mode = { 'n', 'x', 'o' }, '<cmd>HopChar1<cr>', desc = 'Hop char' },
      { '<leader>hb', mode = { 'n', 'x', 'o' }, '<cmd>HopChar2<cr>', desc = 'Hop bigram' },
      { '<leader>h/', mode = { 'n', 'x', 'o' }, '<cmd>HopPattern<cr>', desc = 'Hop search' },
      { '<leader>hl', mode = { 'n', 'x', 'o' }, '<cmd>HopLine<cr>', desc = 'Hop line' },
      { '<leader>hp', mode = { 'n', 'x', 'o' }, '<cmd>HopPasteChar1<cr>', desc = 'Hop paste' },
      { '<leader>hy', mode = { 'n', 'x', 'o' }, '<cmd>HopYankChar1<cr>', desc = 'Hop yank' },
    },
  },
  {
    'folke/flash.nvim',
    enabled = false,
    event = 'VeryLazy',
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
}
