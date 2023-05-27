return {
  {
    "freddiehaddad/base16-nvim",
    priority = 1000,
    config = false,
    enabled = false,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = true,
  },
  {
    "oxfist/night-owl.nvim",
    lazy = false,
    -- dev = true,
    enabled = false,
    priority = 1000,
  },
  {
    "loctvl842/monokai-pro.nvim",
    priority = 1000,
    name = "monokai-pro",
    opts = {
      day_night = {
        enable = true, -- turn off by default
        day_filter = "spectrum", -- classic | octagon | pro | machine | ristretto | spectrum
        night_filter = "spectrum", -- classic | octagon | pro | machine | ristretto | spectrum
      },
    },
    config = true,
  },
  { "EdenEast/nightfox.nvim", priority = 1000 },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    enabled = false,
    config = function()
      vim.o.background = "dark"
      require("gruvbox").setup({
        contrast = "hard", -- can be "hard", "soft" or empty string
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nightfox",
    },
  },
}
