return {
  -- {
  --   'rebelot/kanagawa.nvim',
  --   priority = 1000,
  --   lazy = false,
  --   config = function()
  --     require('kanagawa').setup()
  --     -- vim.cmd.colorscheme("kanagawa")
  --   end,
  -- },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    lazy = false,
    config = function()
      require('rose-pine').setup {
        variant = 'moon', -- auto, main, moon, or dawn
        dark_variant = 'moon', -- main, moon, or dawn
        extend_background_behind_borders = true,

        enable = {
          terminal = true,
          legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
          migrations = true, -- Handle deprecated options automatically
        },

        highlight_groups = {
          CmpItemKindSupermaven = { fg = 'iris' },
          MiniStarterSection = { fg = 'iris', bold = true },
          MiniStarterHeader = { fg = 'gold' },
          MiniStarterFooter = { fg = 'rose' },
          HopNextKey1 = { fg = 'iris', bg = 'surface' },
          HopNextKey2 = { fg = 'foam', bg = 'base' },
          -- Comment = { fg = "foam" },
          -- VertSplit = { fg = "muted", bg = "muted" },
        },
      }
      vim.cmd 'colorscheme rose-pine'
    end,
  },
  -- {
  --   'dgox16/oldworld.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   enabled = false,
  --   config = function()
  --     local p = require 'oldworld.palette'
  --     local colorbuddy = require 'colorbuddy'
  --     local Color = colorbuddy.Color
  --     local colors = colorbuddy.colors
  --     local styles = colorbuddy.styles
  --     local Group = colorbuddy.Group
  --     require('oldworld').setup()
  --     vim.cmd.colorscheme 'oldworld'
  --     -- Add all the colors from the palette to colorbuddy
  --     for k, v in pairs(p) do
  --       Color.new(k, v)
  --     end
  --     -- bg = "#161617",
  --     --    fg = "#c9c7cd",
  --     --    subtext1 = "#b4b1ba",
  --     --    subtext2 = "#9f9ca6",
  --     --    subtext3 = "#8b8693",
  --     --    subtext4 = "#6c6874",
  --     --    bg_dark = "#131314",
  --     --    black = "#27272a",
  --     --    red = "#ea83a5",
  --     --    green = "#90b99f",
  --     --    yellow = "#e6b99d",
  --     --    purple = "#aca1cf",
  --     --    magenta = "#e29eca",
  --     --    orange = "#f5a191",
  --     --    blue = "#92a2d5",
  --     --    lavender = "#a4a6c9",
  --     --    cyan = "#85b5ba",
  --     --    bright_black = "#353539",
  --     --    bright_red = "#f591b2",
  --     --    bright_green = "#9dc6ac",
  --     --    bright_yellow = "#f0c5a9",
  --     --    bright_purple = "#b9aeda",
  --     --    bright_magenta = "#ecaad6",
  --     --    bright_orange = "#ffae9f",
  --     --    bright_blue = "#a6b6e9",
  --     --    bright_cyan = "#99c9ce",
  --     --    gray0 = "#18181a",
  --     --    gray1 = "#1b1b1c",
  --     --    gray2 = "#2a2a2c",
  --     --    gray3 = "#313134",
  --     --    gray4 = "#3b3b3e",
  --     --    -- Special
  --     --    none = "NONE",
  --     Group.new('MiniJump2dSpot', colors.gray1, colors.lavender, styles.bold)
  --     Group.new('FzfLuaBorder', colors.bg)
  --     Group.new('MiniStarterHeader', colors.blue, colors.bg)
  --     Group.new('MiniStarterFooter', colors.blue, colors.bg)
  --     Group.new('MiniStarterSection', colors.magenta, colors.bg, styles.bold)
  --     Group.new('MiniStarterQuery', colors.red, colors.bg, styles.bold)
  --     Group.new('FlashLabel', colors.red)
  --     Group.new('FlashBackdrop', colors.gray4)
  --     Group.new('FlashCursor', colors.subtext2)
  --     Group.new('FlashCurrent', colors.orange)
  --     Group.new('CmpItemKindSupermaven', colors.purple)
  --   end,
  -- },
  -- {
  --   'jesseleite/nvim-noirbuddy',
  --   name = 'noirbuddy',
  --   dependencies = {
  --     { 'tjdevries/colorbuddy.nvim' },
  --   },
  --   lazy = false,
  --   priority = 1000,
  --   -- config = function()
  --   --   local colorbuddy = require 'colorbuddy'
  --   --   local Color = colorbuddy.Color
  --   --   local colors = colorbuddy.colors
  --   --   local Group = colorbuddy.Group
  --   --
  --   --   require('noirbuddy').setup {
  --   --     colors = {
  --   --       background = '#0f0f0f',
  --   --
  --   --       primary = '#a7a7a7',
  --   --       secondary = '#ffffff',
  --   --       colors = {
  --   --         noir_0 = '#ffffff', -- `noir_0` is light for dark themes, and dark for light themes
  --   --         noir_1 = '#f5f5f5',
  --   --         noir_2 = '#d5d5d5',
  --   --         noir_3 = '#b4b4b4',
  --   --         noir_4 = '#a7a7a7',
  --   --         noir_5 = '#949494',
  --   --         noir_6 = '#737373',
  --   --         noir_7 = '#535353',
  --   --         noir_8 = '#323232',
  --   --         noir_9 = '#212121', -- `noir_9` is dark for dark themes, and light for light themes
  --   --         diagnostic_error = '#FF304F',
  --   --         diagnostic_warning = '#D7BA7D',
  --   --         diagnostic_info = '#bdacd1',
  --   --         diagnostic_hint = '#969696',
  --   --         diff_add = '#69AD7A',
  --   --         diff_change = '#D7BA7D',
  --   --         diff_delete = '#FF304F',
  --   --       },
  --   --     },
  --   --   }
  --   --   Color.new('lavender', '#775ADA')
  --   --   Color.new('blue', '#28C7FA')
  --   --   Group.new('CmpItemKindSupermaven', colors.lavender)
  --   --   Group.new('MiniStarterSection', colors.diagnostic_error)
  --   --   Group.new('MiniStarterFooter', colors.blue)
  --   --   Group.new('MiniStarterHeader', colors.lavender)
  --   --   Group.new('FlashLabel', colors.blue)
  --   --   Group.new('FlashBackdrop', colors.noir_7)
  --   --   Group.new('FlashCursor', colors.lavender)
  --   --   Group.new('FlashCurrent', colors.diagnostic_error)
  --   --   Group.new('FlashMatch', colors.lavender)
  --   --   Group.new('NoiceCursor', colors.lavender)
  --   --   Group.new('Identifier', colors.secondary)
  --   --   Group.new('@identifier', colors.secondary)
  --   --   Group.new('@lsp.type.function', colors.secondary)
  --   --   Group.new('@lsp.type.method', colors.secondary)
  --   --   Group.new('Function', colors.secondary)
  --   --   Group.new('@function', colors.secondary)
  --   --   Group.new('@function.builtin', colors.secondary)
  --   --   Group.new('@function.call', colors.secondary)
  --   --   Group.new('@constructor', colors.secondary)
  --   --   Group.new('@comment', colors.primary)
  --   --   Group.new('@string', colors.primary)
  --   --   Group.new('Cursor', colors.background, colors.lavender)
  --   -- end,
  -- },
}
