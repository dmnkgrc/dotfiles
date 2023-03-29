return {
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
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
            },
          },
        },
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
}
