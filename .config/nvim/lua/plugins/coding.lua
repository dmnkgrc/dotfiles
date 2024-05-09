return {
  {
    "monaqa/dial.nvim",
    keys = {
      {
        "<C-a>",
        function()
          require("dial.map").manipulate("increment", "normal")
        end,
        "Increment",
      },
      {
        "<C-x>",
        function()
          require("dial.map").manipulate("decrement", "normal")
        end,
        "Decrement",
      },
      {
        "g<C-a>",
        function()
          require("dial.map").manipulate("increment", "gnormal")
        end,
        "Increment g",
      },
      {
        "g<C-x>",
        function()
          require("dial.map").manipulate("decrement", "gnormal")
        end,
        "Decrement g",
      },
      {
        "<C-a>",
        function()
          require("dial.map").manipulate("increment", "visual")
        end,
        mode = "v",
        desc = "Increment visual selection",
      },
      {
        "<C-x>",
        function()
          require("dial.map").manipulate("decrement", "visual")
        end,
        mode = "v",
        desc = "Decrement visual selection",
      },
      {
        "g<C-a>",
        function()
          require("dial.map").manipulate("increment", "gvisual")
        end,
        mode = "v",
        desc = "Increment visual selection g",
      },
      {
        "g<C-x>",
        function()
          require("dial.map").manipulate("decrement", "gvisual")
        end,
        mode = "v",
        desc = "Decrement visual selection g",
      },
    },
  },
  {
    "MaximilianLloyd/tw-values.nvim",
    keys = {
      { "<leader>sv", "<cmd>TWValues<cr>", desc = "Show tailwind CSS values" },
    },
    opts = {
      border = "rounded", -- Valid window border style,
      show_unknown_classes = true, -- Shows the unknown classes popup
    },
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    keys = {
      {
        "<leader>op",
        function()
          local peek = require("peek")
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
        desc = "Peek (Markdown Preview)",
      },
    },
  },
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
    opts = {
      tabout = {
        enable = true,
        hopout = true,
      },
    },
  },
  {
    "dmmulroy/tsc.nvim",
    config = true,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        prettier = {
          cwd = require("conform.util").root_file({ ".prettierrc.js", ".prettierrc.cjs" }),
          require_cwd = true,
        },
      },
    },
  },
  {
    "otavioschwanck/arrow.nvim",
    opts = {
      show_icons = true,
      leader_key = ";",
      buffer_leader_key = "m",
    },
  },
}
