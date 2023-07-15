return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {},
      },
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    name = "colorizer",
    opts = {
      user_default_options = {
        tailwind = "both",
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
      { "js-everts/cmp-tailwind-colors", config = true },
    },
    opts = function(_, opts)
      -- original LazyVim kind icon formatter
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        if item.kind == "Color" then
          item = require("cmp-tailwind-colors").format(entry, item)

          if item.kind ~= "Color" then
            item.menu = ""
            return item
          end
        end
        format_kinds(entry, item) -- add icons
        return item
      end
    end,
  },
}
