return {
  {
    "haydenmeade/neotest-jest",
  },
  { "marilari88/neotest-vitest" },
  {
    "rouge8/neotest-rust",
  },
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        "neotest-vitest",
        "neotest-jest",
        "neotest-rust",
      },
    },
    keys = {
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Test Last",
      },
      {
        "<leader>ta",
        function()
          require("neotest").run.attach()
        end,
        desc = "Test Attach",
      },
    },
  },
}
