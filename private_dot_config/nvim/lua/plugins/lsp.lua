return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    lazy = true,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "L3MON4D3/LuaSnip" },
      { "onsails/lspkind.nvim" },
      { "saadparwaiz1/cmp_luasnip" },
      { "js-everts/cmp-tailwind-colors", config = true },
    },
    commit = "6c84bc75c64f778e9f1dcb798ed41c7fcb93b639",
    config = function()
      -- Here is where you configure the autocompletion settings.
      -- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
      -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

      require("lsp-zero.cmp").extend()

      -- And you can configure cmp even more, if you want to.
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local icons = require("config.icons")
      local cmp_action = require("lsp-zero.cmp").action()
      local cmp_mapping = cmp.mapping
      local cmp_types = require("cmp.types.cmp")
      local luasnip = require("luasnip")
      local utils = require("config.utils")
      cmp.setup({
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local max_width = 0
            if max_width ~= 0 and #vim_item.abbr > max_width then
              vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. icons.ui.Ellipsis
            end
            if lspkind.presets.default[vim_item.kind] ~= nil then
              vim_item.kind = lspkind.presets.default[vim_item.kind] .. " " .. vim_item.kind
            end

            if entry.source.name == "codeium" then
              vim_item.kind = icons.misc.Robot
              vim_item.kind_hl_group = "CmpItemKindCopilot"
            end

            if entry.source.name == "crates" then
              vim_item.kind = icons.misc.Package
              vim_item.kind_hl_group = "CmpItemKindCrate"
            end

            if entry.source.name == "emoji" then
              vim_item.kind = icons.misc.Smiley
              vim_item.kind_hl_group = "CmpItemKindEmoji"
            end
            if vim_item.kind == "Color" then
              vim_item = require("cmp-tailwind-colors").format(entry, vim_item)

              if vim_item.kind ~= "Color" then
                vim_item.menu = "Color"
                return vim_item
              end
            end

            vim_item.menu = ({
              nvim_lsp = "(LSP)",
              emoji = "(Emoji)",
              path = "(Path)",
              calc = "(Calc)",
              vsnip = "(Snippet)",
              luasnip = "(Snippet)",
              buffer = "(Buffer)",
              tmux = "(TMUX)",
              codeium = "(Codeium)",
              treesitter = "(TreeSitter)",
            })[entry.source.name]
            vim_item.dup = ({
              buffer = 1,
              path = 1,
              nvim_lsp = 0,
              luasnip = 1,
            })[entry.source.name] or 0
            return vim_item
          end,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          }),
        },
        sources = {
          {
            name = "codeium",
            -- keyword_length = 0,
            max_item_count = 3,
            trigger_characters = {
              {
                ".",
                ":",
                "(",
                "'",
                '"',
                "[",
                ",",
                "#",
                "*",
                "@",
                "|",
                "=",
                "-",
                "{",
                "/",
                "\\",
                "+",
                "?",
                " ",
                -- "\t",
                -- "\n",
              },
            },
          },
          {
            name = "nvim_lsp",
            entry_filter = function(entry, ctx)
              local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
              if kind == "Snippet" and ctx.prev_context.filetype == "java" then
                return false
              end
              if kind == "Text" then
                return false
              end
              return true
            end,
          },

          { name = "path" },
          { name = "luasnip" },
          { name = "nvim_lua" },
          { name = "buffer" },
          { name = "calc" },
          { name = "emoji" },
          { name = "treesitter" },
          { name = "crates" },
          { name = "tmux" },
        },
        mapping = {
          ["<C-b>"] = cmp_action.luasnip_jump_backward(),

          ["<Down>"] = cmp_mapping(cmp_mapping.select_next_item({ behavior = cmp_types.SelectBehavior.Select }), {
            "i",
          }),
          ["<Up>"] = cmp_mapping(cmp_mapping.select_prev_item({ behavior = cmp_types.SelectBehavior.Select }), {
            "i",
          }),
          ["<C-d>"] = cmp_mapping.scroll_docs(-4),
          ["<C-f>"] = cmp_mapping.scroll_docs(4),
          ["<C-y>"] = cmp_mapping({
            i = cmp_mapping.confirm({ behavior = cmp_types.ConfirmBehavior.Replace, select = false }),
            c = function(fallback)
              if cmp.visible() then
                cmp.confirm({ behavior = cmp_types.ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end,
          }),
          ["<Tab>"] = cmp_mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif utils.jumpable(1) then
              luasnip.jump(1)
            elseif utils.has_words_before() then
              -- cmp.complete()
              fallback()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp_mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-Space>"] = cmp_mapping.complete(),
          ["<C-e>"] = cmp_mapping.abort(),
          ["<CR>"] = cmp_mapping(function(fallback)
            if cmp.visible() then
              local confirm_opts = vim.deepcopy({
                behavior = cmp_types.ConfirmBehavior.Replace,
                select = false,
              }) -- avoid mutating the original opts below
              local is_insert_mode = function()
                return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
              end
              if is_insert_mode() then -- prevent overwriting brackets
                confirm_opts.behavior = cmp_types.ConfirmBehavior.Insert
              end
              local entry = cmp.get_selected_entry()
              local is_codeium = entry and entry.source.name == "codeium"
              if is_codeium then
                confirm_opts.behavior = cmp_types.ConfirmBehavior.Replace
                confirm_opts.select = true
              end
              if cmp.confirm(confirm_opts) then
                return -- success, exit early
              end
            end
            fallback() -- if not exited early, always fallback
          end),
        },
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      {
        "williamboman/mason.nvim",
        build = function()
          pcall(vim.cmd, "MasonUpdate")
        end,
      },
      { "b0o/schemastore.nvim" },
    },
    keys = {
      { "K",  "<cmd>lua vim.lsp.buf.hover()<CR>",           desc = "Hover" },
      { "gd", "<cmd>lua vim.lsp.buf.definition()<CR>",      desc = "Go to definition" },
      { "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>",     desc = "Go to declaration" },
      { "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>",  desc = "Go to implementation" },
      { "gl", "<cmd>lua vim.diagnostic.open_float()<CR>",   desc = "Go to float diagnostic" },
      { "go", "<cmd>lua vim.lsp.buf.type_definition()<CR>", desc = "Go to type definition" },
      { "gr", "<cmd>Telescope lsp_references<cr>",          desc = "Go to references" },
      { "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>",    desc = "Previous diagnostic" },
      { "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>",    desc = "Next diagnostic" },
      {
        "<leader>lc",
        function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              only = { "source.removeUnused.ts" },
              diagnostics = {},
            },
          })
        end,
        desc = "Remove Unused Imports",
      },
    },
    config = function()
      local icons = require("config.icons")
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_lspconfig()

      -- see :help lsp-zero-guide:integrate-with-mason-nvim
      -- to learn how to use mason.nvim with lsp-zero
      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = {
          "svelte",
          "rust_analyzer",
          "lua_ls",
          "jsonls",
          "bashls",
          "vimls",
          "tailwindcss",
          "eslint",
          "tsserver",
          "js-debug-adapter",
        },
        automatic_installation = {
          exclude = { "rust_analyzer" },
        },
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require("lspconfig").lua_ls.setup(lua_opts)
          end,
        },
      })

      require("mason-lspconfig").setup({
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require("lspconfig").lua_ls.setup(lua_opts)
          end,
        },
      })

      lsp_zero.format_on_save({
        servers = {
          ["lua_ls"] = { "lua" },
          ["rust_analyzer"] = { "rust" },
        },
      })

      lsp_zero.set_sign_icons({
        error = icons.diagnostics.Error,
        warn = icons.diagnostics.Warning,
        hint = icons.diagnostics.Hint,
        info = icons.diagnostics.Information,
      })

      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim", "custom_nvim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
              hint = { enable = true },
              telemetry = { enable = false },
            },
          },
        },
      })

      lspconfig.solidity.setup({
        cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
        filetypes = { "solidity", "sol" },
        root_dir = require("lspconfig.util").find_git_ancestor,
        single_file_support = true,
      })

      lspconfig.jsonls.setup({
        settings = {
          json = {
            schema = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      lspconfig.eslint.setup({
        filestypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
        config = function()
          vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function(event)
              local client = vim.lsp.get_active_clients({ bufnr = event.buf, name = "eslint" })[1]
              if client then
                vim.cmd("EslintFixAll")
              end
            end,
          })
        end,
      })

      lspconfig.rust_analyzer.setup({
        settings = {
          ["rust-analyzer"] = {
            lens = {
              enable = true,
            },
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            -- Add clippy lints for Rust.
            check = {
              enable = true,
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      })
      lspconfig.tailwindcss.setup({
        settings = {
          tailwindCSS = {
            lint = {
              cssConflict = "error",
            },
            classAttributes = { "class", "className", "style" },
            experimental = {
              classRegex = {
                { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "cx\\(([^)]*)\\)",  "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "tv\\(([^)]*)\\)",  "[\"'`]([^\"'`]*).*?[\"'`]" },
                "tw`([^`]*)",
                { "tw.style\\(([^)]*)\\)", "'([^']*)'" },
              },
            },
          },
        },
      })

      lspconfig.tsserver.setup({
        settings = {
          typescript = {
            format = {
              indentSize = vim.o.shiftwidth,
              convertTabsToSpaces = vim.o.expandtab,
              tabSize = vim.o.tabstop,
            },
          },
          javascript = {
            format = {
              indentSize = vim.o.shiftwidth,
              convertTabsToSpaces = vim.o.expandtab,
              tabSize = vim.o.tabstop,
            },
          },
          preferences = {
            quotePreference = "single",
            includeCompletionsForImportStatements = true,
            includeCompletionsForModuleExports = true,
            importModuleSpecifierEnding = "auto",
            importModuleSpecifierPreference = "non-relative",
            allowRenameOfImportPath = true,
          },
          completions = {
            completeFunctionCalls = true,
          },
        },
      })

      local mason_tool_installer = require("mason-tool-installer")
      mason_tool_installer.setup({
        ensure_installed = {
          "prettier",  -- prettier formatter
          "prettierd", -- prettierd formatter
          "stylua",    -- lua formatter
        },
      })

      lsp_zero.setup()
    end,
    keys,
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {},
  },
  {
    "Wansmer/symbol-usage.nvim",
    event = "BufReadPre", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    config = function()
      require("symbol-usage").setup()
    end,
  },
}
