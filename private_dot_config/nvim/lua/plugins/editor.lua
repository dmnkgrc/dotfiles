return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
    keys = {
      { "<leader>e", false },
    },
  },
  {
    "kelly-lin/ranger.nvim",
    name = "ranger-nvim",
    lazy = false,
    keys = {
      {
        "<leader>e",
        function()
          require("ranger-nvim").open(true)
        end,
        "Open Ranger",
      },
    },
    opts = {
      replace_netrw = true,
    },
  },
  {
    "max397574/better-escape.nvim",
    config = true,
    opts = {
      mapping = { "jk", "jj" },
    },
  },
}
