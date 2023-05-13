return {
  {
    "imNel/monorepo.nvim",
    name = "monorepo",
    config = true,
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>m",
        function()
          require("telescope").extensions.monorepo.monorepo()
        end,
        desc = "Monorepo",
      },
      {
        "<leader>n",
        function()
          require("monorepo").toggle_project()
        end,
        desc = "Toggle monorepo project",
      },
    },
  },
}
