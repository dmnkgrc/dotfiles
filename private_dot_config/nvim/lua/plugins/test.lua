return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "rouge8/neotest-rust",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest"
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rust"),
          require("neotest-jest"),
          require("neotest-vitest"),
        },
        status = { virtual_text = true },
        output = { open_on_run = true },
        quickfix = {
          open = function()
            vim.cmd("Trouble quickfix")
          end,
        },
      })
    end,
    keys = {
      {
        "<leader>tt", function() require("neotest").run.run() end, desc = "Run Nearest"
      },
      {
        "<leader>tT", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File"
      },
      {
        "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary"
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Show Output"
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel"
      },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
    }
  }
}
