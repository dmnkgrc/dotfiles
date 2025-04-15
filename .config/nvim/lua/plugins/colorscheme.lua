return {
  {
    "oxfist/night-owl.nvim",
    lazy = false,         -- make sure we load this during startup if it is your main colorscheme
    priority = 1000,      -- make sure to load this before all the other start plugins
    opts = {
      transparent = true, -- enable transparent background
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
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "night-owl",
    },
  },
}
