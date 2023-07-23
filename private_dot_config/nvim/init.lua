-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("lspconfig").tailwindcss.setup({
  settings = {
    tailwindCSS = {
      lint = {
        cssConflict = "error",
      },
      classAttributes = { "class", "className", "style" },
      experimental = {
        classRegex = {
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cx\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          {"tv\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]"},
          "tw`([^`]*)",
          {"tw.style\\(([^)]*)\\)", "'([^']*)'"}
        },
      },
    },
  },
})
