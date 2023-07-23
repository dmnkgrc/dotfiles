return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {},
      },
      setup = {},
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
}
