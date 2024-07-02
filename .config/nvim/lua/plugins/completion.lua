return {
  {
    'hrsh7th/nvim-cmp',
    version = false, -- last release is way too old
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
        opts = {
          history = true,
          delete_check_events = 'TextChanged',
        },
        keys = {
          {
            '<C-j>',
            function()
              require('luasnip').jump(1)
            end,
            mode = { 'i', 's' },
            desc = 'LuaSnip jump',
          },
          {
            '<C-k>',
            function()
              require('luasnip').jump(-1)
            end,
            mode = { 'i', 's' },
            desc = 'LuaSnip jump back',
          },
        },
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'luckasRanarison/tailwind-tools.nvim',
      'onsails/lspkind-nvim',
      'saadparwaiz1/cmp_luasnip',
    },
    opts = function()
      vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
      local lspkind = require 'lspkind'
      lspkind.init {}
      vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })

      local cmp = require 'cmp'
      return {
        auto_brackets = {}, -- configure any filetype to auto add brackets
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ['<CR>'] = cmp.mapping.confirm { select = true },
        },
        sources = cmp.config.sources {
          -- { name = 'supermaven' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' },
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        formatting = {
          format = require('lspkind').cmp_format {
            -- symbol_map = { Supermaven = "" },
            before = require('tailwind-tools.cmp').lspkind_format,
          },
        },
        experimental = {
          ghost_text = {
            hl_group = 'CmpGhostText',
          },
        },
      }
    end,
    ---@param opts cmp.ConfigSchema | {auto_brackets?: string[]}
    config = function(_, opts)
      local cmp = require 'cmp'
      cmp.setup(opts)

      local ls = require 'luasnip'
      ls.config.set_config {
        history = false,
        updateevents = 'TextChanged,TextChangedI',
      }
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end
      -- local Kind = cmp.lsp.CompletionItemKind
      -- cmp.event:on('confirm_done', function(event)
      --   if not vim.tbl_contains(opts.auto_brackets or {}, vim.bo.filetype) then
      --     return
      --   end
      --   local entry = event.entry
      --   local item = entry:get_completion_item()
      --   if vim.tbl_contains({ Kind.Function, Kind.Method }, item.kind) then
      --     local keys = vim.api.nvim_replace_termcodes('()<left>', false, false, true)
      --     vim.api.nvim_feedkeys(keys, 'i', true)
      --   end
      -- end)
    end,
  },
}
