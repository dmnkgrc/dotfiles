return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        style = 'night',
      }
      vim.cmd [[colorscheme tokyonight]]
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      require('kanagawa').setup {
        transparent = true, -- do not set background color
      }
      -- vim.cmd.colorscheme 'kanagawa'
    end,
  },
}
