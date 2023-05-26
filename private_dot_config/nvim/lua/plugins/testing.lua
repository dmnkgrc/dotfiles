return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "rouge8/neotest-rust",
      "nvim-neotest/neotest-vim-test",
      "haydenmeade/neotest-jest",
      "marilari88/neotest-vitest",
      "vim-test/vim-test",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rust"),
          require("neotest-jest"),
          require("neotest-vitest"),
          -- require("neotest-vim-test")({
          --   ignore_file_types = { "python", "vim", "lua", "rust" },
          -- }),
        },
      })
    end,
    keys = {
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test Summary",
      },
      {
        "<leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Test Nearest",
      },
      {
        "<leader>tT",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Test File",
      },
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
      {
        "<leader>to",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Test Output",
      },
    },
  },
  {
    "vim-test/vim-test",
    dependencies = {
      "preservim/vimux",
    },
    keys = {},
    config = function()
      vim.g["test#strategy"] = "vimux"
    end,
  },
}
