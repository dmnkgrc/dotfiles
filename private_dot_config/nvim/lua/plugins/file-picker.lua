return {
  {
    "lmburns/lf.nvim",
    lazy = false,
    config = true,
    opts = {
      escape_quit = true,
      border = "rounded",
    },
    keys = { { "<leader>e", "<Cmd>Lf<CR>", desc = "Open lf" } },
    dependencies = { "akinsho/toggleterm.nvim" },
  },
}
