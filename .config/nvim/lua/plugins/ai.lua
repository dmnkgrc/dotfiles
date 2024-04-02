return {
  {
    "Exafunction/codeium.nvim",
    opts = {
      enable_chat = true,
    },
  },
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
}
