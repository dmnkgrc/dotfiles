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
  },
  {
    "aserowy/tmux.nvim",
    name = "tmux",
    config = true
  },
  {
    "jubnzv/virtual-types.nvim",
  },
}
