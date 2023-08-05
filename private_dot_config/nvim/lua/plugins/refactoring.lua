return {
  "ThePrimeagen/refactoring.nvim",
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-treesitter/nvim-treesitter" }
  },
  config = true,
}
