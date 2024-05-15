return {
  {
    'robitx/gp.nvim',
    opts = {},
    keys = {
      { '<leader>ao', '<cmd>GpChatNew vsplit<CR>', mode = { 'n', 'v' }, desc = 'Run ChatGPT' },
      { '<leader>ad', '<cmd>GpChatDelete<CR>', desc = 'Delete last chat' },
      { '<leader>ap', '<cmd>GpChatPaste<CR>', mode = { 'n', 'v' }, desc = 'Paste into last chat' },
      { '<leader>ar', '<cmd>GpRewrite<CR>', mode = { 'n', 'v' }, desc = 'Rewrite using ChatGPT' },
    },
  },
  {
    'Hashiraee/supermaven-nvim',
    event = 'VeryLazy',
    branch = 'multiline-issue',
    opts = {
      keymaps = {
        accept_suggestion = '<A-f>',
        clear_suggestion = '<A-c>',
      },
      color = {
        suggestion_color = '#6396BD',
        cterm = 244,
      },
    },
  },
  -- {
  --   "monkoose/neocodeium",
  --   event = "VeryLazy",
  --   opts = {},
  --   keys = {
  --     {
  --       "<A-f>",
  --       function()
  --         require("neocodeium").accept()
  --       end,
  --       mode = { "i" },
  --       desc = "Accept codeium suggestion",
  --     },
  --     {
  --       "<A-w>",
  --       function()
  --         require("neocodeium").accept_word()
  --       end,
  --       mode = { "i" },
  --       desc = "Accept next word from suggestion",
  --     },
  --     {
  --       "<A-l>",
  --       function()
  --         require("neocodeium").accept_line()
  --       end,
  --       mode = { "i" },
  --       desc = "Accept line from suggestion",
  --     },
  --     {
  --       "<A-e>",
  --       function()
  --         require("neocodeium").cycle_or_complete()
  --       end,
  --       mode = { "i" },
  --       desc = "Cycle or complete forwad",
  --     },
  --     {
  --       "<A-r>",
  --       function()
  --         require("necodeium").cycle_or_complete(-1)
  --       end,
  --       mode = { "i" },
  --       desc = "Cycle or complete backwards",
  --     },
  --     {
  --       "<A-c>",
  --       function()
  --         require("neocodeium").clear()
  --       end,
  --       mode = { "i" },
  --       desc = "Clear suggestions",
  --     },
  --   },
  -- },
}
