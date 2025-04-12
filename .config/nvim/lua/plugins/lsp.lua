return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            typescript = {
              preferences = {
                importModuleSpecifier = "non-relative",
              },
            },
            javascript = {
              preferences = {
                importModuleSpecifier = "non-relative",
              },
            },
          }
        },
        tailwindcss = {
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  { "([\"'`][^\"'`]*.*?[\"'`])", "[\"'`]([^\"'`]*).*?[\"'`]" },
                },
              },
            },
          },
        },
      },
      setup = {
        vtsls = function(_, opts)
          local util = require("lspconfig.util")
          opts.on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
          opts.root_dir = function(fname)
            return util.root_pattern(".trunk", ".git")(fname)
          end
          require("lspconfig").vtsls.setup(opts)
          return true
        end,
        pyright = function(_, opts)
          local util = require("lspconfig.util")
          opts.root_dir = function(fname)
            return util.root_pattern(".trunk", ".git")(fname)
          end
          opts.on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
          require("lspconfig").pyright.setup(opts)
          return true
        end,
        ruff = function(_, opts)
          local util = require("lspconfig.util")
          opts.root_dir = function(fname)
            return util.root_pattern(".trunk", ".git")(fname)
          end
          opts.on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
          require("lspconfig").ruff.setup(opts)
          return true
        end,
        tailwindcss = function(_, opts)
          opts.filetypes = opts.filetypes or {}

          --- @param ft string
          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)

          opts.settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  { "([\"'`][^\"'`]*.*?[\"'`])", "[\"'`]([^\"'`]*).*?[\"'`]" }
                },
              },
            },
          }

          vim.list_extend(opts.filetypes, opts.filetypes_include or {})
          require("lspconfig").tailwindcss.setup(opts)
          return true
        end,
      }
    },
  },
}
