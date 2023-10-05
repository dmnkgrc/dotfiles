return {
  -- {
  --   "lmburns/lf.nvim",
  --   lazy = false,
  --   config = true,
  --   opts = {
  --     escape_quit = true,
  --     border = "rounded",
  --   },
  --   keys = {
  --     -- { "<leader>e", "<Cmd>Lf<CR>",                                      desc = "Open lf" },
  --     { "<leader>E", "<Cmd>lua require('lf').start({ dir: 'gwd' })<CR>", desc = "Open lf in gwd" }
  --   },
  --   dependencies = { "akinsho/toggleterm.nvim" },
  -- },

  {
    "DreamMaoMao/yazi.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>e", "<Cmd>Yazi<CR>", desc = "Toggle Yazi" },
    },
  }
}
