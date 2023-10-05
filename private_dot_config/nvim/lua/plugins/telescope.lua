return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    version = false,
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'jvgrootveld/telescope-zoxide',
      'kyazdani42/nvim-web-devicons',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-ui-select.nvim',
      'kkharji/sqlite.lua',
      'nvim-telescope/telescope-frecency.nvim',
      'debugloop/telescope-undo.nvim',
      'ThePrimeagen/git-worktree.nvim',
      'piersolenski/telescope-import.nvim',
    },
    config = function()
      local telescope = require 'telescope'
      telescope.setup {
        file_ignore_patterns = { '%.git/.' },
        defaults = {
          hidden = true,
          prompt_prefix = '   ',
          file_ignore_patterns = { 'node_modules', 'package-lock.json' },
          initial_mode = 'insert',
          select_strategy = 'reset',
          sorting_strategy = 'ascending',
          layout_config = {
            prompt_position = 'top',
            preview_cutoff = 120,
          },
        },
        pickers = {
          live_grep = {
            only_sort_text = true,
          },
          grep_string = {
            only_sort_text = true,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = 'smart_case',       -- or "ignore_case" or "respect_case"
          },
          ['ui-select'] = {
            require('telescope.themes').get_dropdown {},
          },
          frecency = {
            default_workspace = 'CWD',
            show_scores = true,
            show_unindexed = true,
            disable_devicons = false,
            ignore_patterns = {
              '*.git/*',
              '*/tmp/*',
              '*/lua-language-server/*',
            },
          },
          undo = {},
          import = {
            insert_at_top = true,
          },
        },
      }
      telescope.load_extension 'fzf'
      telescope.load_extension 'ui-select'
      telescope.load_extension 'refactoring'
      telescope.load_extension 'zoxide'
      telescope.load_extension 'frecency'
      telescope.load_extension 'harpoon'
      telescope.load_extension 'projects'
      -- telescope.load_extension('yank_history')
      telescope.load_extension 'undo'
      telescope.load_extension 'git_worktree'
      telescope.load_extension 'import'
    end,
    keys = {
      { '<space><space>', '<cmd>Telescope find_files hidden=true<cr>', desc = 'Find File' },
      { '<space>u',       '<cmd>Telescope undo<cr>',                   desc = 'Toggle UndoTree' },
      -- Marks
      {
        '<leader>mm',
        '<cmd>Telescope marks<cr>',
        desc = 'Marks',
      },
      -- git
      {
        '<leader>go',
        '<cmd>Telescope git_status<cr>',
        desc = 'Open changed file',
      },
      {
        '<leader>gb',
        '<cmd>Telescope git_branches<cr>',
        desc = 'Checkout branch',
      },
      {
        '<leader>gC',
        '<cmd>Telescope git_commits<cr>',
        desc = 'Checkout commit',
      },
      -- search
      { '<leader>sf', '<cmd>Telescope find_files hidden=true<cr>', desc = 'Find File' },
      { '<leader>sh', '<cmd>Telescope help_tags<cr>',              desc = 'Find Help' },
      {
        '<leader>sH',
        '<cmd>Telescope highlights<cr>',
        desc = 'Find highlight groups',
      },
      { '<leader>sM', '<cmd>Telescope man_pages<cr>',             desc = 'Man Pages' },
      {
        '<leader>so',
        '<cmd>Telescope oldfiles<cr>',
        desc = 'Open Recent File',
      },
      { '<leader>sR', '<cmd>Telescope registers<cr>',             desc = 'Registers' },
      { '<leader>st', '<cmd>Telescope live_grep hidden=true<cr>', desc = 'Live Grep' },
      {
        '<leader>sT',
        '<cmd>Telescope grep_string hidden=true<cr>',
        desc = 'Grep String',
      },
      { '<leader>sk', '<cmd>Telescope keymaps<cr>',  desc = 'Keymaps' },
      { '<leader>sC', '<cmd>Telescope commands<cr>', desc = 'Commands' },
      {
        '<leader>sl',
        '<cmd>Telescope resume<cr>',
        desc = 'Resume last search',
      },
      {
        '<leader>sc',
        '<cmd>Telescope git_commits<cr>',
        desc = 'Git commits',
      },
      {
        '<leader>sB',
        '<cmd>Telescope git_branches<cr>',
        desc = 'Git branches',
      },
      { '<leader>ss', '<cmd>Telescope git_status<cr>',  desc = 'Git status' },
      { '<leader>sS', '<cmd>Telescope git_stash<cr>',   desc = 'Git stash' },
      { '<leader>sz', '<cmd>Telescope zoxide list<cr>', desc = 'Zoxide' },
      { '<leader>se', '<cmd>Telescope frecency<cr>',    desc = 'Frecency' },
      { '<leader>sb', '<cmd>Telescope buffers<cr>',     desc = 'Buffers' },
      { '<leader>sp', '<cmd>Telescope projects<cr>',    desc = 'Projects' },
      {
        '<leader>sdc',
        '<cmd>Telescope dap commands<cr>',
        desc = 'Dap Commands',
      },
      {
        '<leader>sdb',
        '<cmd>Telescope dap list_breakpoints<cr>',
        desc = 'Dap Breakpoints',
      },
      {
        '<leader>sdg',
        '<cmd>Telescope dap configurations<cr>',
        desc = 'Dap Configurations',
      },
      {
        '<leader>sdv',
        '<cmd>Telescope dap variables<cr>',
        desc = 'Dap Variables',
      },
      { '<leader>sdf', '<cmd>Telescope dap frames<cr>',     desc = 'Dap Frames' },
      {
        '<leader>si',
        '<cmd>Telescope import<cr>',
        desc = 'Import',
      },
      -- lsp
      { '<leader>lR',  '<cmd>Telescope lsp_references<cr>', desc = 'References' },
      {
        '<leader>lw',
        '<cmd>Telescope diagnostics<cr>',
        desc = 'Diagnostics',
      },
      {
        '<leader>lt',
        [[ <Esc><Cmd>lua require('telescope').extensions.refactoring.refactors()<CR>]],
        desc = 'Refactor',
      },
      -- buffer
      {
        '<leader>bf',
        '<cmd>Telescope buffers previewer=false<cr>',
        desc = 'Find buffer',
      },
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
      -- harpoon
      {
        '<leader>hs',
        "<cmd>lua require('telescope').extensions.harpoon.marks()<cr>",
        desc = 'Harpoon marks',
      },
    },
  },
}
