return {
  {
    "luckasRanarison/tailwind-tools.nvim",
    opts = {},
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "luckasRanarison/tailwind-tools.nvim",
      "onsails/lspkind-nvim",
    },
    opts = function(_, opts)
      table.insert(
        opts.formatting,
        require("lspkind").cmp_format({
          before = require("tailwind-tools.cmp").lspkind_format,
        })
      )
    end,
  },
}
