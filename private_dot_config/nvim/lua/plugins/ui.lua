return {
  {
    "nvim-lualine/lualine.nvim",
  },

  {
    "stevearc/oil.nvim",
    name = "oil",
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
    config = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>lua require('oil').open()<cr>", desc = "Open parent directory" },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
    },
  },
}
