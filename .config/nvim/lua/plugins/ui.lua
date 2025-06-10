return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = LazyVim.config.icons

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },

          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            { "filetype",                   icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { LazyVim.lualine.pretty_path() },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {
            { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
        },
        extensions = { "lazy", "fzf" },
      }

      return opts
    end,
  },
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
          _____                    _____                    _____                    _____
         /\    \                  /\    \                  /\    \                  /\    \
        /::\    \                /::\____\                /::\____\                /::\____\
       /::::\    \              /::::|   |               /::::|   |               /:::/    /
      /::::::\    \            /:::::|   |              /:::::|   |              /:::/    /
     /:::/\:::\    \          /::::::|   |             /::::::|   |             /:::/    /
    /:::/  \:::\    \        /:::/|::|   |            /:::/|::|   |            /:::/____/
   /:::/    \:::\    \      /:::/ |::|   |           /:::/ |::|   |           /::::\    \
  /:::/    / \:::\    \    /:::/  |::|___|______    /:::/  |::|   | _____    /::::::\____\________
 /:::/    /   \:::\ ___\  /:::/   |::::::::\    \  /:::/   |::|   |/\    \  /:::/\:::::::::::\    \
/:::/____/     \:::|    |/:::/    |:::::::::\____\/:: /    |::|   /::\____\/:::/  |:::::::::::\____\
\:::\    \     /:::|____|\::/    / ~~~~~/:::/    /\::/    /|::|  /:::/    /\::/   |::|~~~|~~~~~
 \:::\    \   /:::/    /  \/____/      /:::/    /  \/____/ |::| /:::/    /  \/____|::|   |
  \:::\    \ /:::/    /               /:::/    /           |::|/:::/    /         |::|   |
   \:::\    /:::/    /               /:::/    /            |::::::/    /          |::|   |
    \:::\  /:::/    /               /:::/    /             |:::::/    /           |::|   |
     \:::\/:::/    /               /:::/    /              |::::/    /            |::|   |
      \::::::/    /               /:::/    /               /:::/    /             |::|   |
       \::::/    /               /:::/    /               /:::/    /              \::|   |
        \::/____/                \::/    /                \::/    /                \:|   |
         ~~                       \/____/                  \/____/                  \|___|


 ]],
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    -- REMOVE THIS once this issue is fixed: https://github.com/yioneko/vtsls/issues/159
    opts = {
      routes = {
        {
          filter = {
            event = "notify",
            find = "Request textDocument/inlayHint failed",
          },
          opts = { skip = true },
        },
      },
    },
  },
}
