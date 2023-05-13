return {
  { "rebelot/kanagawa.nvim", lazy = false, name = "kanagawa", config = true, opts = {
    transparent = true,
  } },
  { "rose-pine/neovim", name = "rose-pine", lazy = false, config = true, opts = {
    disable_background = true,
  } },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    cconfig = true,
    opts = {
      transparent_background = true,
    },
  },
  -- {
  --   "javiorfo/nvim-nyctophilia",
  --   lazy = false,
  -- },
  -- {
  --   "oxfist/night-owl.nvim",
  --   lazy = false,
  -- },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-dragon",
    },
  },
}
