return {
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
    priority = 1000,
    enabled = false,
  },
  { "EdenEast/nightfox.nvim", priority = 1000 },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      require("gruvbox").setup({
        contrast = "hard",
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
