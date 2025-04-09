return {
  {
    "ahmedkhalf/project.nvim",
    opts = {
      manual_mode = true,
      detection_methods = { "pattern", "lsp" },
      patterns = { ".git", "Makefile" },
      show_hidden = true,
    },
  }
}
