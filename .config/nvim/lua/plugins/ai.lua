return {
  -- {
  --   'monkoose/neocodeium',
  --   event = 'VeryLazy',
  --   config = function()
  --     local neocodeium = require 'neocodeium'
  --     neocodeium.setup()
  --     vim.keymap.set('i', '<A-f>', neocodeium.accept)
  --     vim.keymap.set('i', '<A-c>', neocodeium.clear)
  --     vim.keymap.set('i', '<A-w>', neocodeium.accept_word)
  --     vim.keymap.set('i', '<A-a>', neocodeium.accept_line)
  --   end,
  -- },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any opts here
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
  {
    'supermaven-inc/supermaven-nvim',
    event = 'VeryLazy',
    opts = {
      keymaps = {
        accept_suggestion = '<A-f>',
        clear_suggestion = '<A-c>',
        accept_word = '<A-w>',
      },
      -- disable_inline_completion = true,
      color = {
        suggestion_color = '#c4a7e7',
      },
    },
  },
}
