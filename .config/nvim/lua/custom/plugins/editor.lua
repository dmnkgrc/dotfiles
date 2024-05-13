return {
  {
    'echasnovski/mini.files',
    version = false,
    config = function()
      require('mini.files').setup {
        mappings = {
          go_in_plus = '<CR>',
        },
        windows = {
          preview = true,
          width_preview = 100,
        },
      }
      local MiniFiles = require 'mini.files'
      local map_split = function(buf_id, lhs, direction)
        local rhs = function()
          -- Make new window and set it as target
          local new_target_window
          vim.api.nvim_win_call(MiniFiles.get_target_window(), function()
            vim.cmd(direction .. ' split')
            new_target_window = vim.api.nvim_get_current_win()
          end)

          MiniFiles.set_target_window(new_target_window)
        end

        -- Adding `desc` will result into `show_help` entries
        local desc = 'Split ' .. direction
        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Tweak keys to your liking
          map_split(buf_id, 'gs', 'belowright horizontal')
          map_split(buf_id, 'gv', 'belowright vertical')
        end,
      })
    end,
    keys = {
      {
        '<leader>e',
        function()
          require('mini.files').open()
        end,
        desc = 'Toggle MiniFiles',
      },
    },
  },
  -- search/replace in multiple files
  {
    'nvim-pack/nvim-spectre',
    build = false,
    cmd = 'Spectre',
    opts = { open_cmd = 'noswapfile vnew' },
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
    },
  },

  -- Fuzzy finder.
  -- The default key bindings to find files will use Telescope's
  -- `find_files` or `git_files` depending on whether the
  -- directory is a git repo.
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      {
        'jvgrootveld/telescope-zoxide',
      },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
      {
        'debugloop/telescope-undo.nvim',
      },
      {
        'ThePrimeagen/git-worktree.nvim',
      },
      {
        'piersolenski/telescope-import.nvim',
      },
    },
    keys = {
      { '<space><space>', '<cmd>Telescope find_files hidden=true<cr>', desc = 'Find File' },
      { '<space>fu', '<cmd>Telescope undo<cr>', desc = 'Toggle UndoTree' },
      { '<leader>sz', '<cmd>Telescope zoxide list<cr>', desc = 'Zoxide' },
      -- worktrees
      {
        '<leader>sw',
        "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>",
        desc = 'List Git Worktrees',
      },
      {
        '<leader>sW',
        "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>",
        desc = 'Create Git Worktree',
      },
      {
        '<leader>si',
        '<cmd>Telescope import<cr>',
        desc = 'Import',
      },
      {
        '<leader>,',
        '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>',
        desc = 'Switch Buffer',
      },
      { '<leader>/', '<cmd>Telescope live_grep<cr>', desc = 'Grep (Root Dir)' },
      { '<leader>:', '<cmd>Telescope command_history<cr>', desc = 'Command History' },
      -- find
      { '<leader>fb', '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>', desc = 'Buffers' },
      { '<space>f>', '<cmd>Telescope find_files hidden=true<cr>', desc = 'Find Files (Root Dir)' },
      { '<space>f>', '<cmd>Telescope find_files hidden=true cwd=false<cr>', desc = 'Find Files (cwd)' },
      { '<leader>fg', '<cmd>Telescope git_files<cr>', desc = 'Find Files (git-files)' },
      { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent' },
      -- git
      { '<leader>gc', '<cmd>Telescope git_commits<CR>', desc = 'Commits' },
      { '<leader>gs', '<cmd>Telescope git_status<CR>', desc = 'Status' },
      -- search
      { '<leader>s"', '<cmd>Telescope registers<cr>', desc = 'Registers' },
      { '<leader>sa', '<cmd>Telescope autocommands<cr>', desc = 'Auto Commands' },
      { '<leader>sb', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = 'Buffer' },
      { '<leader>sc', '<cmd>Telescope command_history<cr>', desc = 'Command History' },
      { '<leader>sC', '<cmd>Telescope commands<cr>', desc = 'Commands' },
      { '<leader>sd', '<cmd>Telescope diagnostics bufnr=0<cr>', desc = 'Document Diagnostics' },
      { '<leader>sD', '<cmd>Telescope diagnostics<cr>', desc = 'Workspace Diagnostics' },
      { '<leader>sg', '<cmd>Telescope live_grep<cr>', desc = 'Grep (Root Dir)' },
      { '<leader>sG', '<cmd>Telescope live_grep cwd=false<cr>', desc = 'Grep (cwd)' },
      { '<leader>sh', '<cmd>Telescope help_tags<cr>', desc = 'Help Pages' },
      { '<leader>sH', '<cmd>Telescope highlights<cr>', desc = 'Search Highlight Groups' },
      { '<leader>sk', '<cmd>Telescope keymaps<cr>', desc = 'Key Maps' },
      { '<leader>sM', '<cmd>Telescope man_pages<cr>', desc = 'Man Pages' },
      { '<leader>sm', '<cmd>Telescope marks<cr>', desc = 'Jump to Mark' },
      { '<leader>so', '<cmd>Telescope vim_options<cr>', desc = 'Options' },
      { '<leader>sR', '<cmd>Telescope resume<cr>', desc = 'Resume' },
      { '<leader>sw', '<cmd>lua require("telescope.builtin").live_grep({ word_match = "-w" })', mode = 'v', desc = 'Word (Root Dir)' },
      { '<leader>sW', '<cmd>lua require("telescope.builtin").live_grep({ word_match = "-w", cwd = false })', mode = 'v', desc = 'Word (cwd)' },
      { '<leader>uC', '<cmd>lua require("telecope.builtin").colorscheme({ enable_preview = true })<cr>', desc = 'Colorscheme with Preview' },
      {
        '<leader>ss',
        function()
          require('telescope.builtin').lsp_document_symbols {
            symbols = require('lazyvim.config').get_kind_filter(),
          }
        end,
        desc = 'Goto Symbol',
      },
      {
        '<leader>sS',
        function()
          require('telescope.builtin').lsp_dynamic_workspace_symbols {
            symbols = require('lazyvim.config').get_kind_filter(),
          }
        end,
        desc = 'Goto Symbol (Workspace)',
      },
    },
    opts = {
      extensions = {
        undo = {},
        import = {
          insert_at_top = true,
        },
      },
    },
  },

  -- Flash enhances the built-in search functionality by showing labels
  -- at the end of each match, letting you quickly jump to a specific
  -- location.
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    vscode = true,
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- Flash Telescope config
  -- {
  --   'nvim-telescope/telescope.nvim',
  --   optional = true,
  --   opts = function(_, opts)
  --     local function flash(prompt_bufnr)
  --       require('flash').jump {
  --         pattern = '^',
  --         label = { after = { 0, 0 } },
  --         search = {
  --           mode = 'search',
  --           exclude = {
  --             function(win)
  --               return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'TelescopeResults'
  --             end,
  --           },
  --         },
  --         action = function(match)
  --           local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
  --           picker:set_selection(match.pos[1] - 1)
  --         end,
  --       }
  --     end
  --     opts.defaults = vim.tbl_deep_extend('force', opts.defaults or {}, {
  --       mappings = { n = { s = flash }, i = { ['<c-s>'] = flash } },
  --     })
  --   end,
  -- },

  -- which-key helps you remember key bindings by showing a popup
  -- with the active keybindings of the command you started typing.
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { 'n', 'v' },
        ['g'] = { name = '+goto' },
        ['gs'] = { name = '+surround' },
        ['z'] = { name = '+fold' },
        [']'] = { name = '+next' },
        ['['] = { name = '+prev' },
        ['<leader><tab>'] = { name = '+tabs' },
        ['<leader>b'] = { name = '+buffer' },
        ['<leader>c'] = { name = '+code' },
        ['<leader>f'] = { name = '+file/find' },
        ['<leader>g'] = { name = '+git' },
        ['<leader>gh'] = { name = '+hunks' },
        ['<leader>q'] = { name = '+quit/session' },
        ['<leader>s'] = { name = '+search' },
	["<leader>t"] = { name = "+test" },
        ['<leader>u'] = { name = '+ui' },
        ['<leader>w'] = { name = '+windows' },
        ['<leader>x'] = { name = '+diagnostics/quickfix' },
      },
    },
    config = function(_, opts)
      local wk = require 'which-key'
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },

  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  {
    'RRethy/vim-illuminate',
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { 'lsp' },
      },
    },
    config = function(_, opts)
      require('illuminate').configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set('n', key, function()
          require('illuminate')['goto_' .. dir .. '_reference'](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference', buffer = buffer })
      end

      map(']]', 'next')
      map('[[', 'prev')

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map(']]', 'next', buffer)
          map('[[', 'prev', buffer)
        end,
      })
    end,
    keys = {
      { ']]', desc = 'Next Reference' },
      { '[[', desc = 'Prev Reference' },
    },
  },

  -- buffer remove
  {
    'echasnovski/mini.bufremove',

    keys = {
      {
        '<leader>bd',
        function()
          local bd = require('mini.bufremove').delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = 'Delete Buffer',
      },
      -- stylua: ignore
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },

  -- better diagnostics list and others
  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'Trouble' },
    opts = { use_diagnostic_signs = true },
    keys = {
      { '<leader>xx', '<cmd>TroubleToggle document_diagnostics<cr>', desc = 'Document Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Workspace Diagnostics (Trouble)' },
      { '<leader>xL', '<cmd>TroubleToggle loclist<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>TroubleToggle quickfix<cr>', desc = 'Quickfix List (Trouble)' },
      {
        '[q',
        function()
          if require('trouble').is_open() then
            require('trouble').previous { skip_groups = true, jump = true }
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Previous Trouble/Quickfix Item',
      },
      {
        ']q',
        function()
          if require('trouble').is_open() then
            require('trouble').next { skip_groups = true, jump = true }
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Next Trouble/Quickfix Item',
      },
    },
  },

  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
  {
    'max397574/better-escape.nvim',
    config = true,
    opts = {
      mapping = { 'jk', 'jj' },
    },
  },
  {
    'jesseleite/nvim-macroni',
  },
}
