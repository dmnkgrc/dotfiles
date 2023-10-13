return {
  {
    'glepnir/dashboard-nvim',
    event = 'VimEnter',
    name = 'dashboard',
    opts = function()
      local logo = [[
    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝

    ]]

      logo = string.rep('\n', 8) .. logo .. '\n\n'

      local opts = {
        theme = 'doom',
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, '\n'),
          center = {
            { action = 'Telescope find_files', desc = ' Find file', icon = ' ', key = 'f' },
            { action = 'ene | startinsert', desc = ' New file', icon = ' ', key = 'n' },
            { action = 'Telescope oldfiles', desc = ' Recent files', icon = ' ', key = 'r' },
            { action = 'Telescope live_grep', desc = ' Find text', icon = ' ', key = 'g' },
            { action = 'e $MYVIMRC', desc = ' Config', icon = ' ', key = 'c' },
            { action = 'lua require("persistence").load()', desc = ' Restore Session', icon = ' ', key = 's' },
            { action = 'Lazy', desc = ' Lazy', icon = '󰒲 ', key = 'l' },
            { action = 'qa', desc = ' Quit', icon = ' ', key = 'q' },
          },
          footer = function()
            local stats = require('lazy').stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms' }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(' ', 43 - #button.desc)
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == 'lazy' then
        vim.cmd.close()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'DashboardLoaded',
          callback = function()
            require('lazy').show()
          end,
        })
      end

      return opts
    end,

    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  -- {
  --   'goolord/alpha-nvim',
  --   enabled = true,
  --   event = 'VimEnter',
  --   lazy = true,
  --   opts = function()
  --     local dashboard = require 'alpha.themes.dashboard'
  --
  --     dashboard.section.header.val = vim.split(logo, '\n')
  --     dashboard.section.buttons.val = {
  --       dashboard.button('f', ' ' .. ' Find file', ':Telescope find_files hidden=true<CR>'),
  --       dashboard.button('n', ' ' .. ' New file', ':ene <BAR> startinsert <CR>'),
  --       dashboard.button('r', ' ' .. ' Recent files', ':Telescope oldfiles hidden=true<CR>'),
  --       dashboard.button('g', ' ' .. ' Find text', ':Telescope live_grep <CR>'),
  --       dashboard.button('c', ' ' .. ' Config', ':e ~/.config/nvim/ <CR>'),
  --       dashboard.button('s', ' ' .. ' Restore Session', [[:lua require("persistence").load() <cr>]]),
  --       dashboard.button('l', '󰒲 ' .. ' Lazy', ':Lazy<CR>'),
  --       dashboard.button('q', ' ' .. ' Quit', ':qa<CR>'),
  --     }
  --     for _, button in ipairs(dashboard.section.buttons.val) do
  --       button.opts.hl = 'AlphaButtons'
  --       button.opts.hl_shortcut = 'AlphaShortcut'
  --     end
  --     dashboard.section.header.opts.hl = 'AlphaHeader'
  --     dashboard.section.buttons.opts.hl = 'AlphaButtons'
  --     dashboard.section.footer.opts.hl = 'AlphaFooter'
  --     dashboard.opts.layout[1].val = 8
  --     return dashboard
  --   end,
  --   config = function(_, dashboard)
  --     -- close Lazy and re-open when the dashboard is ready
  --     if vim.o.filetype == 'lazy' then
  --       vim.cmd.close()
  --       vim.api.nvim_create_autocmd('User', {
  --         pattern = 'AlphaReady',
  --         callback = function()
  --           require('lazy').show()
  --         end,
  --       })
  --     end
  --
  --     require('alpha').setup(dashboard.opts)
  --
  --     vim.api.nvim_create_autocmd('User', {
  --       pattern = 'LazyVimStarted',
  --       callback = function()
  --         local stats = require('lazy').stats()
  --         local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
  --         dashboard.section.footer.val = '⚡ Neovim loaded ' .. stats.count .. ' plugins in ' .. ms .. 'ms'
  --         pcall(vim.cmd.AlphaRedraw)
  --       end,
  --     })
  --   end,
  -- },
}
