-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("lspconfig").tailwindcss.setup({
  settings = {
    tailwindCSS = {
      lint = {
        cssConflict = "error",
      },
      experimental = {
        classRegex = {
          { "tv\\((([^()]*|\\([^()]*\\))*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cva\\((([^()]*|\\([^()]*\\))*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
        },
      },
    },
  },
})
