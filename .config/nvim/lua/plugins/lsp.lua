return {
  { -- LSP Configuration & Plugins
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v4.x',
    dependencies = {
      'neovim/nvim-lspconfig',
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      { 'j-hui/fidget.nvim', opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim', opts = {} },
      { 'ibhagwan/fzf-lua' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/nvim-cmp' },
    },
    config = function()
      local lsp_zero = require 'lsp-zero'
      local lsp_attach = function(_, bufnr)
        local opts = { buffer = bufnr }

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<leader>cf', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
      end
      lsp_zero.extend_lspconfig {
        sign_text = true,
        lsp_attach = lsp_attach,
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      }
      require('mason').setup {}
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup {}
          end,
          tailwindcss = function()
            require('lspconfig').tailwindcss.setup {
              settings = {
                tailwindCSS = {
                  lint = {
                    cssConflict = 'error',
                  },
                  experimental = {
                    classRegex = {
                      { 'tv\\((([^()]*|\\([^()]*\\))*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
                      { 'cva\\((([^()]*|\\([^()]*\\))*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
                    },
                  },
                },
              },
            }
          end,
          vtsls = function()
            require('lspconfig').vtsls.setup {
              settings = {
                complete_function_calls = true,
                vtsls = {
                  enableMoveToFileCodeAction = true,
                  autoUseWorkspaceTsdk = true,
                  experimental = {
                    completion = {
                      enableServerSideFuzzyMatch = true,
                    },
                  },
                },
                typescript = {
                  preferences = {
                    importModuleSpecifier = 'non-relative',
                  },
                  updateImportsOnFileMove = { enabled = 'always' },
                  suggest = {
                    completeFunctionCalls = true,
                  },
                  inlayHints = {
                    enumMemberValues = { enabled = true },
                    functionLikeReturnTypes = { enabled = true },
                    parameterNames = { enabled = 'literals' },
                    parameterTypes = { enabled = true },
                    propertyDeclarationTypes = { enabled = true },
                    variableTypes = { enabled = false },
                  },
                },
              },
              on_attach = lsp_attach,
            }
          end,
          eslint = function()
            require('lspconfig').eslint.setup {
              on_attach = function(_, bufnr)
                vim.api.nvim_create_autocmd('BufWritePre', {
                  buffer = bufnr,
                  command = 'EslintFixAll',
                })
              end,
            }
          end,
        },
      }
    end,
  },
}
