return {
  {
    "simrat39/rust-tools.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "simrat39/rust-tools.nvim",
    },
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
        rust_analyzer = function(_, opts)
          require("rust-tools").setup({ server = opts })
          return true
        end,
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
}
