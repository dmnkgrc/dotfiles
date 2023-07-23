return {
  {
    "jcdickinson/codeium.nvim",
    dependencies = {
      {
        "jcdickinson/http.nvim",
        build = "cargo build --workspace --release",
      },
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({})
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      { "js-everts/cmp-tailwind-colors", config = true },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local kind_icons = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "ﴯ",
        Interface = "",
        Module = "",
        Property = "ﰠ",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
        Codeium = "",
      }
      local cmp = require("cmp")

      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "codeium", priority = 10 } }))
      opts.formatting = {
        format = function(entry, item)
          if item.kind == "Color" then
            item = require("cmp-tailwind-colors").format(entry, item)

            if item.kind ~= "Color" then
              item.menu = "Color"
              return item
            end
          end

          item.menu = item.kind
          item.kind = kind_icons[item.kind] .. " "
          return item
        end,
      }
    end,
  },
}
