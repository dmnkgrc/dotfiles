return {
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
