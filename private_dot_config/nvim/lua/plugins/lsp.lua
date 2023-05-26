return {
  {
    "simrat39/rust-tools.nvim"
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      autoformat = true,
      ---@type lspconfig.options
      servers = {
        ansiblels = {},
        bashls = {},
        clangd = {},
        cssls = {},
        dockerls = {},
        eslint = {},
        tsserver = {},
        svelte = {},
        html = {},
        marksman = {},
        pyright = {},
        rust_analyzer = {},
        yamlls = {},
        lua_ls = {},
        teal_ls = {},
        vimls = {},
      },
      setup = {
        tsserver = function()
          require("typescript").setup({
            server = {
              init_options = {
                preferences = {
                  allowRenameOfImportPath = true,
                  importModuleSpecifierEnding = "auto",
                  importModuleSpecifierPreference = "non-relative",
                  includeCompletionsForImportStatements = true,
                  includeCompletionsForModuleExports = true,
                  quotePreference = "single",
                },
              },
            },
          })
        end,
      },
    },
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    opts = {
      -- add your options that should be passed to the setup() function here
      position = "right",
    },
  },
  {
    "dnlhc/glance.nvim",
    name = "glance",
    config = true,
  },
}
