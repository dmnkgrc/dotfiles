return {
  {
    "azorng/goose.nvim",
    enabled = false,
    opts = {
      keymap = {
        global = {
          toggle = '<leader>ag',                 -- Open goose. Close if opened
          open_input = '<leader>ai',             -- Opens and focuses on input window on insert mode
          open_input_new_session = '<leader>aI', -- Opens and focuses on input window on insert mode. Creates a new session
          open_output = '<leader>ao',            -- Opens and focuses on output window
          toggle_focus = '<leader>at',           -- Toggle focus between goose and last window
          close = '<leader>aq',                  -- Close UI windows
          toggle_fullscreen = '<leader>af',      -- Toggle between normal and fullscreen mode
          select_session = '<leader>as',         -- Select and load a goose session
          goose_mode_chat = '<leader>amc',       -- Set goose mode to `chat`. (Tool calling disabled. No editor context besides selections)
          goose_mode_auto = '<leader>ama',       -- Set goose mode to `auto`. (Default mode with full agent capabilities)
          configure_provider = '<leader>ap',     -- Quick provider and model switch from predefined list
          diff_open = '<leader>ad',              -- Opens a diff tab of a modified file since the last goose prompt
          diff_next = '<leader>a]',              -- Navigate to next file diff
          diff_prev = '<leader>a[',              -- Navigate to previous file diff
          diff_close = '<leader>ac',             -- Close diff view tab and return to normal editing
          diff_revert_all = '<leader>ara',       -- Revert all file changes since the last goose prompt
          diff_revert_this = '<leader>art',      -- Revert current file changes since the last goose prompt
        },
        window = {
          submit = '<cr>',               -- Submit prompt
          close = '<esc>',               -- Close UI windows
          stop = '<C-c>',                -- Stop goose while it is running
          next_message = ']]',           -- Navigate to next message in the conversation
          prev_message = '[[',           -- Navigate to previous message in the conversation
          mention_file = '@',            -- Pick a file and add to context. See File Mentions section
          toggle_pane = '<tab>',         -- Toggle between input and output panes
          prev_prompt_history = '<up>',  -- Navigate to previous prompt in history
          next_prompt_history = '<down>' -- Navigate to next prompt in history
        }
      },
      providers = {
        openrouter = {
          "anthropic/claude-3.5-sonnet",
          "google/gemini-2.5-pro-preview",
        },
      }
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          anti_conceal = { enabled = false },
        },
      }
    },
  },
  {
    'milanglacier/minuet-ai.nvim',
    name = 'minuet',
    opts = {
      provider = 'openai_fim_compatible',
      request_timeout = 2.5,
      provider_options = {
        openai_fim_compatible = {
          api_key = 'OPENROUTER_API_KEY',
          end_point = 'https://openrouter.ai/api/v1/completions',
          model = 'mistralai/codestral-2501',
          name = 'Openrouter',
          optional = {
            max_tokens = 256,
            stop = { '\n\n' },
          },
        },
      },
    },
    dependencies = {
      {
        'Saghen/blink.cmp',
        opts = {
          keymap = {
            ['<A-y>'] = {
              function(cmp)
                cmp.show { providers = { 'minuet' } }
              end,
            },
          },
          sources = {
            default = { 'minuet' },
            providers = {
              minuet = {
                name = 'minuet',
                module = 'minuet.blink',
                score_offset = 100,
                transform_items = function(ctx, items)
                  for _, item in ipairs(items) do
                    item.kind_icon = '󰊠'
                    item.kind_name = 'Minuet'
                  end
                  return items
                end,
              },
            },
          },
        },

      }
    },
  },
  {
    "coder/claudecode.nvim",
    config = true,
    keys = {
      { "<leader>a",  nil,                       desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>",     desc = "Toggle Claude" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v",             desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree" },
      },
    },
  }
}
