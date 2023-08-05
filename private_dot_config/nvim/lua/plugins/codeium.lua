return {
  "jcdickinson/codeium.nvim",
  event = 'InsertEnter',
  dependencies = {
    {
      "jcdickinson/http.nvim",
      build = "cargo build --workspace --release",
    },
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = true,
}
