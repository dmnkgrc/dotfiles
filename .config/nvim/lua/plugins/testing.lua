return {
  { "nvim-neotest/neotest-jest" },
  {
    "nvim-neotest/neotest",
    opts = { adapters = { "neotest-jest" } },
  },
  {
    "andythigpen/nvim-coverage",
    version = "*",
    opts = {
      auto_reload = true,
    },
  },
}
