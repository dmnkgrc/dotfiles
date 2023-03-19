return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- they way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
  { "tzachar/cmp-fuzzy-path", dependencies = { "hrsh7th/nvim-cmp", "tzachar/fuzzy.nvim" } },
  {
    "jcdickinson/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "onsails/lspkind.nvim",
    },
    config = function()
      require("codeium").setup({})

      require("cmp").setup({
        sources = {
          { name = "codeium", priority = 10 },
          { name = "nvim_lsp", priority = 8 },
          { name = "luasnip", priority = 7 },
          { name = "buffer", priority = 7 },
          { name = "fuzzy_path", priority = 7 },
        },
        formatting = {
          format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({
              mode = "symbol",
              maxwidth = 50,
              ellipsis_char = "...",
              symbol_map = { Codeium = "" },
            })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "    (" .. (strings[2] or "") .. ")"

            return kind
          end,
        },
      })
    end,
  },
  -- {
  --   "tzachar/cmp-tabnine",
  --   dependencies = { "hrsh7th/nvim-cmp", "onsails/lspkind.nvim" },
  --   build = "./install.sh",
  --   config = function()
  --     local tabnine = require("cmp_tabnine.config")
  --
  --     tabnine:setup({
  --       max_lines = 1000,
  --       max_num_results = 20,
  --       sort = true,
  --       run_on_every_keystroke = true,
  --       snippet_placeholder = "..",
  --     })
  --
  --     local prefetch = vim.api.nvim_create_augroup("prefetch", { clear = true })
  --
  --     vim.api.nvim_create_autocmd("BufRead", {
  --       group = prefetch,
  --       pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  --       callback = function()
  --         require("cmp_tabnine"):prefetch(vim.fn.expand("%:p"))
  --       end,
  --     })
  --
  --
  --   end,
  -- },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        patterns = {
          "tsconfig.json",
          ".eslintrc.js",
          ".git",
          "_darcs",
          ".hg",
          ".bzr",
          ".svn",
          "Makefile",
          "package.json",
        },
      })
      require("telescope").load_extension("projects")
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
      for _, ls in ipairs(language_servers) do
        require("lspconfig")[ls].setup({
          capabilities = capabilities,
          -- you can add other fields for setting up lsp server in this table
        })
      end
      require("ufo").setup()
    end,
  },
  {
    "echasnovski/mini.splitjoin",
    version = false,
    config = function()
      require("mini.splitjoin").setup()
    end,
  },
  {
    "imsnif/kdl.vim",
    event = "BufReadPre *.kdl",
  }
}
