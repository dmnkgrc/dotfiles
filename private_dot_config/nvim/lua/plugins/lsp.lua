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
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<F12>", vim.lsp.buf.definition }
    end,
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
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "prettierd")
      table.insert(opts.ensure_installed, "prettier")
      table.insert(opts.ensure_installed, "codelldb")
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      table.insert(opts.sources, null_ls.builtins.code_actions.refactoring)
      table.insert(
        opts.sources,
        null_ls.builtins.formatting.prettier.with({
          filetypes = { "svelte", "typescript", "typescriptreact", "markdown", "yaml", "json", "javascript" },
        })
      )
      -- table.insert(
      --   opts.sources,
      --   null_ls.builtins.formatting.prettierd.with({
      --     filetypes = { "svelte", "typescript", "typescriptreact", "markdown", "yaml", "json" },
      --   })
      -- )
    end,
  },
}
