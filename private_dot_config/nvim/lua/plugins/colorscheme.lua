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
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
