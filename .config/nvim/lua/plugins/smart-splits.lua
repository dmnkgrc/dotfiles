return {
  {
    'mrjones2014/smart-splits.nvim',
    name = 'smart-splits',
    event = 'VeryLazy',
    keys = {
      -- Move between splits
      {
        '<C-h>',
        function()
          require('smart-splits').move_cursor_left()
        end,
        desc = 'Move Left',
      },
      {
        '<C-j>',
        function()
          require('smart-splits').move_cursor_down()
        end,
        desc = 'Move Down',
      },
      {
        '<C-k>',
        function()
          require('smart-splits').move_cursor_up()
        end,
        desc = 'Move Up',
      },
      {
        '<C-l>',
        function()
          require('smart-splits').move_cursor_right()
        end,
        desc = 'Move Right',
      },
      -- Resize splits
      {
        '<A-h>',
        function()
          require('smart-splits').resize_left()
        end,
        desc = 'Resize Left',
      },
      {
        '<A-j>',
        function()
          require('smart-splits').resize_down()
        end,
        desc = 'Resize Down',
      },
      {
        '<A-k>',
        function()
          require('smart-splits').resize_up()
        end,
        desc = 'Resize Up',
      },
      {
        '<A-l>',
        function()
          require('smart-splits').resize_right()
        end,
        desc = 'Resize Right',
      },
      -- Swap buffers
      {
        '<leader><C-h>',
        function()
          require('smart-splits').swap_buf_left()
        end,
        desc = 'Swap Buffers Left',
      },
      {
        '<leader><C-j>',
        function()
          require('smart-splits').swap_buf_down()
        end,
        desc = 'Swap Buffers Down',
      },
      {
        '<leader><C-k>',
        function()
          require('smart-splits').swap_buf_up()
        end,
        desc = 'Swap Buffers Up',
      },
      {
        '<leader><C-l>',
        function()
          require('smart-splits').swap_buf_right()
        end,
        desc = 'Swap Buffers Right',
      },
    },
  },
}
