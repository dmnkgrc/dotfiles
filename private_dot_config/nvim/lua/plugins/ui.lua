return {
  -- {
  --   "freddiehaddad/feline.nvim",
  --   name = "feline",
  --   config = true,
  -- },
  {
    "akinsho/bufferline.nvim",
    opts = {
      highlights = require("rose-pine.plugins.bufferline"),
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      theme = "rose-pine",
    },
  },
}
