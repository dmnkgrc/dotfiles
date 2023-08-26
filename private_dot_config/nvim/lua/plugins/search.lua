return {
  {
    "kevinhwang91/nvim-bqf",
    opts = {
      filter = {
        fzf = {
          extra_opts = { "--bind", "ctrl-o:toggle-all", "--delimiter", "│" },
        },
      },
    },
    ft = "qf",
  },
  keys = {
    {
      "kevinhwang91/nvim-hlslens",
      { "n",  [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { "N",  [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { "*",  [[*<Cmd>lua require('hlslens').start()<CR>]] },
      { "#",  [[#<Cmd>lua require('hlslens').start()<CR>]] },
      { "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]] },
      { "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]] },
    },
    name = "hlslens",
    config = true,
  },
  {
    "cshuaimin/ssr.nvim",
    opts = {
      border = "rounded",
      min_width = 50,
      min_height = 5,
      max_width = 120,
      max_height = 25,
      keymaps = {
        close = "q",
        next_match = "n",
        prev_match = "N",
        replace_confirm = "<cr>",
        replace_all = "<leader><cr>",
      },
    },
    keys = {
      {
        "<leader>sr",
        function()
          require("ssr").open()
        end,
        mode = { "n", "x" },
        desc = "Search and Replace (SSR)",
      },
    },
  },
  {
    "windwp/nvim-spectre",
    keys = {
      {
        "<leader>rr",
        "<cmd>lua require('spectre').open()<CR>",
        desc =
        "Search and Replace (Spectre)"
      },
      { "<leader>rw", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", desc = "Replace Word (Spectre)" },
      {
        "<leader>rf",
        "<cmd>lua require('spectre').open_file_search()<CR>",
        desc =
        "Replace in File (Spectre)"
      },
    }
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
    }
  }
}
