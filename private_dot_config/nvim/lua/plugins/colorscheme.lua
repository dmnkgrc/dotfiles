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
  },
  {
    "bluz71/vim-nightfly-colors",
    lazy = false,
    -- dev = true,
    priority = 1000,
  },
  { "EdenEast/nightfox.nvim", priority = 1000 },
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.cmd("let g:gruvbox_material_background = 'hard'")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "night-owl",
    },
  },
}
