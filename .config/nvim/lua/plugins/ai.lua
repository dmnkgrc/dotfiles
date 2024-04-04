return {
  -- {
  --   "Exafunction/codeium.nvim",
  --   opts = {
  --     enable_chat = true,
  --   },
  -- },
  {
    enabled = false,
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>ao", "<cmd>ChatGPT<CR>", desc = "Run ChatGPT" },
      { "leader>ae", "<cmd>ChatGPTEditWithInstruction<CR>", mode = { "n", "v" }, desc = "Edit with instruction" },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "robitx/gp.nvim",
    opts = {},
    keys = {
      { "<leader>ao", "<cmd>GpChatNew vsplit<CR>", mode = { "n", "v" }, desc = "Run ChatGPT" },
      { "<leader>ad", "<cmd>GpChatDelete<CR>", desc = "Delete last chat" },
      { "<leader>ap", "<cmd>GpChatPaste<CR>", mode = { "n", "v" }, desc = "Paste into last chat" },
      { "<leader>ar", "<cmd>GpRewrite<CR>", mode = { "n", "v" }, desc = "Rewrite using ChatGPT" },
    },
  },
  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<A-f>",
        function()
          require("neocodeium").accept()
        end,
        mode = { "i" },
        desc = "Accept codeium suggestion",
      },
      {
        "<A-w>",
        function()
          require("neocodeium").accept_word()
        end,
        mode = { "i" },
        desc = "Accept next word from suggestion",
      },
      {
        "<A-l>",
        function()
          require("neocodeium").accept_line()
        end,
        mode = { "i" },
        desc = "Accept line from suggestion",
      },
      {
        "<A-e>",
        function()
          require("neocodeium").cycle_or_complete()
        end,
        mode = { "i" },
        desc = "Cycle or complete forwad",
      },
      {
        "<A-r>",
        function()
          require("necodeium").cycle_or_complete(-1)
        end,
        mode = { "i" },
        desc = "Cycle or complete backwards",
      },
      {
        "<A-c>",
        function()
          require("neocodeium").clear()
        end,
        mode = { "i" },
        desc = "Clear suggestions",
      },
    },
  },
}
