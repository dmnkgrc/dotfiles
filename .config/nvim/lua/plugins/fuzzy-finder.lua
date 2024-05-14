local import_options = {
  -- The regex pattern for the import statement
  regex = [[^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s](.*?)[\"'\s].*)]],
  -- The Vim filetypes
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'react' },
  -- The filetypes that ripgrep supports (find these via `rg --type-list`)
  extensions = { 'js', 'ts' },
}
local function create_file_types_flag()
  local result = ''
  for i, ext in ipairs(import_options.extensions) do
    result = result .. '-t ' .. ext
    if i < #import_options.extensions then
      result = result .. ' '
    end
  end
  return result
end
return {
  -- Fuzzy finder.
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons', 'ThePrimeagen/git-worktree.nvim' },
    opts = {
      commands = { sort_lastused = true },
    },
    keys = {
      {
        '<space><space>',
        function()
          require('fzf-lua').files()
        end,
        desc = 'Find File',
      },
      {
        '<space>,',
        function()
          require('fzf-lua').buffers()
        end,
        desc = 'Switch Buffer',
      },
      {
        '<space>:',
        function()
          require('fzf-lua').command_history()
        end,
        desc = 'Command History',
      },
      -- find
      {
        '<space>fb',
        function()
          require('fzf-lua').buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<space>ff',
        function()
          require('fzf-lua').files()
        end,
        desc = 'Files (Root Dir)',
      },
      {
        '<space>fg',
        function()
          require('fzf-lua').git_files()
        end,
        desc = 'Git Files',
      },
      {
        '<space>fG',
        function()
          require('fzf-lua').git_files { cwd = vim.fn.getcwd() }
        end,
        desc = 'Git Files (CWD)',
      },
      {
        '<space>fr',
        function()
          require('fzf-lua').oldfiles()
        end,
        desc = 'Recent',
      },
      -- git
      {
        '<leader>gc',
        function()
          require('fzf-lua').git_commits()
        end,
        desc = 'Commits',
      },
      {
        '<leader>gs',
        function()
          require('fzf-lua').git_status()
        end,
        desc = 'Status',
      },
      -- search
      {
        '<leader>s"',
        function()
          require('fzf-lua').registers()
        end,
        desc = 'Registers',
      },
      {
        '<leader>sa',
        function()
          require('fzf-lua').autocmds()
        end,
        desc = 'Auto Commands',
      },
      {
        '<leader>sb',
        function()
          require('fzf-lua').lgrep_curbuf()
        end,
        desc = 'Buffer',
      },
      {
        '<space>sc',
        function()
          require('fzf-lua').command_history()
        end,
        desc = 'Command History',
      },
      {
        '<space>sC',
        function()
          require('fzf-lua').commands()
        end,
        desc = 'Commands',
      },
      {
        '<space>sd',
        function()
          require('fzf-lua').diagnostics_document()
        end,
        desc = 'Document Diagnostics',
      },
      {
        '<space>sD',
        function()
          require('fzf-lua').diagnostics_workspace()
        end,
        desc = 'Workspace Diagnostics',
      },
      {
        '<space>sg',
        function()
          require('fzf-lua').live_grep()
        end,
        desc = 'Grep (Root Dir)',
      },
      {
        '<space>sh',
        function()
          require('fzf-lua').helptags()
        end,
        desc = 'Help Pages',
      },
      {
        '<space>sH',
        function()
          require('fzf-lua').highlights()
        end,
        desc = 'Highlight Groups',
      },
      {
        '<space>sk',
        function()
          require('fzf-lua').keymaps()
        end,
        desc = 'Key Maps',
      },
      {
        '<space>sM',
        function()
          require('fzf-lua').manpages()
        end,
        desc = 'Man Pages',
      },
      {
        '<space>sm',
        function()
          require('fzf-lua').marks()
        end,
        desc = 'Marks',
      },
      {
        '<space>sr',
        function()
          require('fzf-lua').resume()
        end,
        desc = 'Resume',
      },
      {
        '<space>ss',
        function()
          require('fzf-lua').lsp_document_symbols()
        end,
        desc = 'LSP Symbols',
      },
      {
        '<space>sS',
        function()
          require('fzf-lua').lsp_live_workspace_symbols()
        end,
        desc = 'LSP Symbols (Workspace)',
      },
      {
        '<space>uC',
        function()
          require('fzf-lua').colorschemes()
        end,
        desc = 'Colorscheme',
      },
      {
        '<space>si',
        function()
          local flags = { '--no-heading', '--no-line-number', '--no-filename' }
          local find_command = table.concat({
            'rg',
            create_file_types_flag(),
            table.concat(flags, ' '),
            string.format('"%s"', import_options.regex),
            '|',
            -- filter out duplicates
            'sort -u',
          }, ' ')
          require('fzf-lua').fzf_exec(find_command, {
            actions = {
              ['default'] = function(selected)
                local original_position = vim.fn.getpos '.'
                vim.cmd 'normal! gg'
                vim.api.nvim_put({ selected[1] }, 'l', false, false)
                vim.fn.setpos('.', original_position)
              end,
            },
          })
        end,
        desc = 'Imports',
      },
      {
        '<leader>sw',
        function()
          local cmd = "git worktree list | cut -d' ' -f1"
          require('fzf-lua').fzf_exec(cmd, {
            actions = {
              ['default'] = function(selected)
                require('git-worktree').switch_worktree(selected[1])
              end,
              ['ctrl-x'] = function(selected)
                require('git-worktree').delete_worktree(selected[1])
              end,
              -- force delete
              ['ctrl-f'] = function(selected)
                require('git-worktree').delete_worktree(selected[1], true)
              end,
            },
          })
        end,
        desc = 'List Git Worktrees',
      },
      {
        '<leader>sW',
        function()
          require('fzf-lua').git_branches {
            actions = {
              ['default'] = function(selected, opts)
                local Window = require 'plenary.window.float'
                local create_input_prompt = function(cb)
                  --[[
    local window = Window.centered({
        width = 30,
        height = 1
    })
    vim.api.nvim_buf_set_option(window.bufnr, "buftype", "prompt")
    vim.fn.prompt_setprompt(window.bufnr, "Worktree Location: ")
    vim.fn.prompt_setcallback(window.bufnr, function(text)
        vim.api.nvim_win_close(window.win_id, true)
        vim.api.nvim_buf_delete(window.bufnr, {force = true})
        cb(text)
    end)

    vim.api.nvim_set_current_win(window.win_id)
    vim.fn.schedule(function()
        vim.nvim_command("startinsert")
    end)
    --]]
                  --

                  local subtree = vim.fn.input 'Path to subtree > '
                  cb(subtree)
                end
                local branch = selected[1]:match '[^%s%*]+' or opts.last_query

                if branch == nil or branch == '' then
                  return
                end
                create_input_prompt(function(name)
                  local path = require 'fzf-lua.path'
                  local utils = require 'fzf-lua.utils'

                  if name == '' then
                    name = branch
                  end
                  utils.info(name)
                  local cmd_add_worktree = path.git_cwd { 'git', 'worktree', 'add', '../' .. name, branch }
                  if branch == selected[1] then
                    cmd_add_worktree = path.git_cwd { 'git', 'worktree', 'add', '-b', branch, '../' .. name }
                  end
                  local output, rc = utils.io_systemlist(cmd_add_worktree)
                  if rc ~= 0 then
                    utils.err(unpack(output))
                  else
                    utils.info(string.format("Created worktree '%s'.", branch))
                  end
                  require('git-worktree').switch_worktree(name)
                end)
              end,
            },
          }
        end,
        desc = 'List Git Worktrees',
      },
    },
  },
}
