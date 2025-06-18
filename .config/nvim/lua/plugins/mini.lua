return {
  -- Collection of various small independent plugins/modules
  {
    'echasnovski/mini.nvim',
    version = false,
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      opts = { enable_autocmd = false },
    },
    config = function()
      -- Better Around/Inside textobjects with tree-sitter integration
      local ai = require 'mini.ai'
      local spec_treesitter = ai.gen_spec.treesitter

      ai.setup {
        n_lines = 500,
        custom_textobjects = {
          -- Function (vaf, dif, etc.)
          f = spec_treesitter { a = '@function.outer', i = '@function.inner' },
          -- Class
          c = spec_treesitter { a = '@class.outer', i = '@class.inner' },
          -- Conditional (if/else)
          o = spec_treesitter { a = '@conditional.outer', i = '@conditional.inner' },
          -- Loop
          l = spec_treesitter { a = '@loop.outer', i = '@loop.inner' },
          -- Parameter/Argument
          a = spec_treesitter { a = '@parameter.outer', i = '@parameter.inner' },
          -- Comment
          C = spec_treesitter { a = '@comment.outer', i = '@comment.inner' },
          -- Call expression
          F = spec_treesitter { a = '@call.outer', i = '@call.inner' },
          -- Block
          B = spec_treesitter { a = '@block.outer', i = '@block.inner' },
          -- Statement
          S = spec_treesitter { a = '@statement.outer', i = '@statement.outer' },
        },
      }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      require('mini.surround').setup {
        mappings = {
          add = 'gsa',
          delete = 'gsd',
          find = 'gsf',
          find_left = 'gsF',
          highlight = 'gsh',
          replace = 'gsr',
          update_n_lines = 'gsn',
        },
      }

      -- Auto pairs
      require('mini.pairs').setup {
        modes = { insert = true, command = true, terminal = false },
        skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        skip_ts = { 'string' },
        skip_unbalanced = true,
        markdown = true,
      }

      -- Comments
      require('mini.comment').setup {
        options = {
          custom_commentstring = function()
            return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
          end,
        },
      }

      -- Simple and easy statusline
      local statusline = require 'mini.statusline'

      -- Custom sections
      local function show_macro_recording()
        local recording_register = vim.fn.reg_recording()
        if recording_register == '' then
          return ''
        else
          return 'Recording @' .. recording_register
        end
      end

      local minuet_processing = false
      local minuet_requests = 0
      local minuet_finished = 0
      local minuet_spinner_frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
      local minuet_spinner_index = 1

      local function show_minuet_status()
        local ok, minuet_module = pcall(require, 'minuet')
        if ok and minuet_module.get_status then
          local status = minuet_module.get_status()
          if status and status.processing then
            minuet_spinner_index = (minuet_spinner_index % #minuet_spinner_frames) + 1
            local spinner = minuet_spinner_frames[minuet_spinner_index]
            if status.n_all_requests and status.n_all_requests > 0 then
              return string.format('%s %s:%s (%d/%d)', spinner, status.provider or 'minuet', status.model or '', status.n_finished_requests or 0, status.n_all_requests)
            else
              return string.format('%s %s:%s', spinner, status.provider or 'minuet', status.model or '')
            end
          end
        end
        
        if minuet_processing then
          minuet_spinner_index = (minuet_spinner_index % #minuet_spinner_frames) + 1
          local spinner = minuet_spinner_frames[minuet_spinner_index]
          if minuet_requests and minuet_requests > 0 then
            return string.format('%s minuet (%d/%d)', spinner, minuet_finished or 0, minuet_requests)
          else
            return spinner .. ' minuet'
          end
        elseif vim.g.minuet_auto_trigger_mode then
          return '🤖'
        else
          return ''
        end
      end

      -- Timer for spinner animation
      local minuet_timer = vim.loop.new_timer()

      -- Set up autocmds for minuet status updates
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MinuetRequestStartedPre',
        callback = function(data)
          if data.data and data.data.n_all_requests then
            minuet_requests = data.data.n_all_requests
            minuet_finished = 0
          end
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MinuetRequestStarted',
        callback = function()
          minuet_processing = true
          -- Start spinner animation
          minuet_timer:start(
            0,
            100,
            vim.schedule_wrap(function()
              if minuet_processing then
                vim.cmd 'redrawstatus'
              else
                minuet_timer:stop()
              end
            end)
          )
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MinuetRequestFinished',
        callback = function(data)
          minuet_finished = (minuet_finished or 0) + 1
          if not minuet_requests or minuet_finished >= minuet_requests then
            minuet_processing = false
            minuet_requests = 0
            minuet_finished = 0
            minuet_timer:stop()
          end
          vim.cmd 'redrawstatus'
        end,
      })

      statusline.setup {
        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            local icons = require 'config.icons'
            local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
            local git = statusline.section_git { trunc_width = 75 }
            local diagnostics = statusline.section_diagnostics {
              trunc_width = 75,
              signs = {
                ERROR = icons.diagnostics.Error,
                WARN = icons.diagnostics.Warn,
                INFO = icons.diagnostics.Info,
                HINT = icons.diagnostics.Hint,
              },
            }
            local filename = statusline.section_filename { trunc_width = 140 }
            local filetype = vim.bo.filetype ~= '' and vim.bo.filetype or 'no ft'
            local location = statusline.section_location { trunc_width = 75 }
            local search = statusline.section_searchcount { trunc_width = 75 }

            -- Add custom sections
            local macro = show_macro_recording()
            local minuet = show_minuet_status()

            return statusline.combine_groups {
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { git } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineFilename', strings = { macro } },
              { hl = 'MiniStatuslineDevinfo', strings = { minuet } },
              { hl = 'MiniStatuslineFilename', strings = { diagnostics } },
              { hl = 'MiniStatuslineFileinfo', strings = { filetype } },
              { hl = mode_hl, strings = { search, location } },
            }
          end,
        },
      }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%p%%'
      end
    end,
  },
}
