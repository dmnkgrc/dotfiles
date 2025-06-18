return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>e', '<cmd>Oil --float<cr>', desc = 'Open parent directory' },
      { '<leader>-', '<cmd>Oil --float<cr>', desc = 'Open parent directory' },
    },
    opts = {
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          return name == '..' or name == '.git'
        end,
      },
      float = {
        padding = 2,
        max_width = 90,
        max_height = 0,
      },
      win_options = {
        wrap = true,
        winblend = 0,
      },
      keymaps = {
        ['<C-c>'] = false,
        ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
        ['q'] = 'actions.close',
      },
    },
  },
}

