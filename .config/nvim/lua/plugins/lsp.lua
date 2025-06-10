return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
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
            },
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
          pyright = {},
          ruff_lsp = {},
          biome = {},
        },
        setup = {
          vtsls = function(_, opts)
            local util = require("lspconfig.util")
            opts.on_attach = function(client)
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
            end
            opts.root_dir = function(fname)
              return util.root_pattern("tsconfig.json", "package.json")(fname)
            end
            require("lspconfig").vtsls.setup(opts)
            return true
          end,
          pyright = function(_, opts)
            local util = require("lspconfig.util")
            opts.root_dir = function(fname)
              return util.root_pattern("pyproject.toml", "setup.py", ".trunk", ".git")(fname)
            end

            -- Look for pyrightconfig in .trunk/configs
            opts.on_new_config = function(config, root_dir)
              local pyright_config = vim.fn.findfile(".trunk/configs/pyrightconfig.json", root_dir)
              if pyright_config ~= "" then
                config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
                  python = {
                    pythonPath = vim.fn.fnamemodify(pyright_config, ":h"),
                  },
                })
                config.cmd_env = config.cmd_env or {}
                config.cmd_env.PYRIGHT_CONFIG_PATH = pyright_config
              end
            end

            require("lspconfig").pyright.setup(opts)
            return true
          end,
          ruff_lsp = function(_, opts)
            local util = require("lspconfig.util")
            opts.root_dir = function(fname)
              return util.root_pattern("pyproject.toml", "ruff.toml", ".trunk", ".git")(fname)
            end
            opts.on_attach = function(client)
              -- Disable hover in favor of pyright
              client.server_capabilities.hoverProvider = false
            end

            -- Look for ruff config in .trunk/configs
            opts.on_new_config = function(config, root_dir)
              local ruff_config = vim.fn.findfile(".trunk/configs/ruff.toml", root_dir)
              if ruff_config ~= "" then
                config.init_options = vim.tbl_deep_extend("force", config.init_options or {}, {
                  settings = {
                    configurationPreference = "filesystemFirst",
                    configuration = ruff_config,
                  },
                })
              end
            end

            require("lspconfig").ruff_lsp.setup(opts)
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
                    { "([\"'`][^\"'`]*.*?[\"'`])", "[\"'`]([^\"'`]*).*?[\"'`]" },
                  },
                },
              },
            }

            vim.list_extend(opts.filetypes, opts.filetypes_include or {})
            require("lspconfig").tailwindcss.setup(opts)
            return true
          end,
        },
      })
    end,
  },
}
