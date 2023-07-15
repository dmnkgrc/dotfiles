return {
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    name = "chatgpt",
    enabled = false,
    config = function()
      require("chatgpt").setup({
        api_key_cmd = 'op read "op://Private/OpenAI API Key/api key" --no-newline',
      })
    end,
    keys = {
      {
        "<leader>cp",
        function()
          require("chatgpt").edit_with_instructions()
        end,
        mode = "v",
        desc = "ChatGPT edit with instructions",
      },
      {
        "<leader>cp",
        function()
          require("chatgpt").edit_with_instructions()
        end,
        desc = "ChatGPT edit with instructions",
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "Exafunction/codeium.vim",
    keys = {
      {
        "<C-g>",
        function()
          return vim.fn["codeium#Accept"]()
        end,
        mode = "i",
        {
          desc = "Codeium accept",
          expr = true,
        },
      },
      {
        "<C-;>",
        function()
          return vim.fn["codeium#CycleCompletions"](1)
        end,
        mode = "i",
        { desc = "Codeium cycle completions", expr = true },
      },
      {
        "<C-,>",
        function()
          return vim.fn["codeium#CycleCompletions"](-1)
        end,
        mode = "i",
        { desc = "Codeium cycle completions", expr = true },
      },
      {
        "<C-x>",
        function()
          return vim.fn["codeium#Clear"]()
        end,
        mode = "i",
        { desc = "Codeium clear", expr = true },
      },
    },
    config = function()
      vim.g.codeium_disable_bindings = 1
    end,
  },
}
