return {
  {
    "folke/tokyonight.nvim",
    enabled = false,
  },
  {
    "catppuccin/nvim",
    enabled = false,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 2000,
    lazy = false,
    config = function()
      require("kanagawa").setup()
      vim.cmd.colorscheme("kanagawa")
    end,
  },
}
