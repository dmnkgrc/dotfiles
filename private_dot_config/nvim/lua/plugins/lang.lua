return {
  -- core language specific extension modules

  {
    "imsnif/kdl.vim",
    event = "BufReadPre *.kdl",
  },
  {
    "echasnovski/mini.hipatterns",
    opts = {
      tailwind = {
        ft = {
          "typescriptreact",
          "javascriptreact",
          "css",
          "javascript",
          "typescript",
          "html",
          "svelte",
        },
      },
    },
  },
}
