return {
  { "rebelot/kanagawa.nvim", name = "kanagawa", config = true, opts = {
    transparent = true,
  } },
  { "rose-pine/neovim", name = "rose-pine", lazy = false, config = true, opts = {
    disable_background = true,
  } },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
