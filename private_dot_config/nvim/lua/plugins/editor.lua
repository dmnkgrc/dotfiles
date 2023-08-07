return {
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({
        stop_eof = true,
        easing_function = "sine",
      })
    end,
  },
  {
    "ecthelionvi/NeoComposer.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    name = "NeoComposer",
    event = { 'BufReadPre', 'BufNewFile' },
    config = true,
  },
  {
    "max397574/better-escape.nvim",
    config = true,
    opts = {
      mapping = { "jk", "jj" },
    },
  },
}
