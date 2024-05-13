local colorbuddy = require("colorbuddy")
local Color = colorbuddy.Color
local colors = colorbuddy.colors
local Group = colorbuddy.Group

require("noirbuddy").setup({
  colors = {
    background = "#1E1E1E",
    primary = "#967bb6",
    secondary = "#CACCCA",
    colors = {
      noir_0 = "#ffffff", -- `noir_0` is light for dark themes, and dark for light themes
      noir_1 = "#f5f5f5",
      noir_2 = "#d5d5d5",
      noir_3 = "#b4b4b4",
      noir_4 = "#a7a7a7",
      noir_5 = "#949494",
      noir_6 = "#737373",
      noir_7 = "#535353",
      noir_8 = "#323232",
      noir_9 = "#212121", -- `noir_9` is dark for dark themes, and light for light themes
      diagnostic_error = "#D16969",
      diagnostic_warning = "#D7BA7D",
      diagnostic_info = "#bdacd1",
      diagnostic_hint = "#969696",
      diff_add = "#69AD7A",
      diff_change = "#D7BA7D",
      diff_delete = "#D16969",
    },
  },
})
Color.new("accent", "#9bb67b")
Color.new("green", "#9bb67b")
Color.new("string", "#bdacd1")
Group.new("FlashLabel", colors.string)
Group.new("FlashBackdrop", colors.noir_7)
Group.new("FlashCursor", colors.secondary)
Group.new("NoiceCursor", colors.primary)
Group.new("Identifier", colors.secondary)
Group.new("@identifier", colors.secondary)
Group.new("@lsp.type.function", colors.accent)
Group.new("@lsp.type.method", colors.accent)
Group.new("Function", colors.accent)
Group.new("@function", colors.accent)
Group.new("@function.builtin", colors.accent)
Group.new("@function.call", colors.accent)
Group.new("@constructor", colors.accent)
Group.new("@comment", colors.accent)
Group.new("@string", colors.string)
