return {
  -- core language specific extension modules
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.dap.core" },
  { import = "lazyvim.plugins.extras.dap.nlua" },
  { import = "plugins.extras.lang.go" },

  {
    "imsnif/kdl.vim",
    event = "BufReadPre *.kdl",
  },
}
