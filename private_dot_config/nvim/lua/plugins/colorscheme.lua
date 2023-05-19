return {
  {
    "freddiehaddad/base16-nvim",
    priority = 1000,
    config = false,
  },
  -- {
  --   "javiorfo/nvim-nyctophilia",
  --   lazy = false,
  -- },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        local opts = {
          hot_reload = {
            enabled = true,
          },
        }
        require("base16-nvim").setup(opts)
      end,
    },
  },
}
