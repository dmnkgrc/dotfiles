return {
  {
    'datsfilipe/vesper.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      -- transparent = true,
    },
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    lazy = false,
    enabled = false,
    opts = {
      transparent = true,
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    enabled = false,
    opts = {
      transparent_background = true,
    }
  },
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    lazy = false,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nightfox",
    },
  },

}
