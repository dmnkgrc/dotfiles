return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",

      "nvim-telescope/telescope.nvim",
    },
    config = true,
    keys = {
      {
        "<leader>gn",
        "<cmd>Neogit<cr>",
        desc = "Open Neogit",
      },
      {
        "<leader>gc",
        "<cmd>Neogit commit<cr>",
        desc = "Neogit commit",
      },
      {
        "<leader>gp",
        "<cmd>Neogit pull<cr>",
        desc = "Neogit pull",
      },
      {
        "<leader>gP",
        "<cmd>Neogit push<cr>",
        desc = "Neogit push",
      },
      {
        "<leader>gd",
        "<cmd>DiffviewOpen<cr>",
        desc = "Open Diffview",
      },
      {
        "<leader>gb",
        "<cmd>Telescope git_branches<cr>",
        desc = "Open Diffview",
      },
    },
  },
  {
    "tpope/vim-fugitive",
  },
}
