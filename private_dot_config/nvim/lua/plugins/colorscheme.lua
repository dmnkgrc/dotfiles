return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    name = "kanagawa",
    priority = 1000,
    config = true,
    opts = {
      transparent = true,
    },
  },
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
      -- color_overrides = {
      --   mocha = {
      --     base = "#000000",
      --     mantle = "#000000",
      --     crust = "#000000",
      --   },
      -- },
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
