return {
  {
    "stevearc/conform.nvim",
    enabled = false,
  },
  {
    "trunk-io/neovim-trunk",
    enabled = true,
    lazy = false,
    -- these are optional config arguments (defaults shown)
    config = {
      -- trunkPath = "trunk",
      -- lspArgs = {},
      -- formatOnSave = true,
      -- formatOnSaveTimeout = 10, -- seconds
      -- logLevel = "info"
    },
    main = "trunk",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
}
