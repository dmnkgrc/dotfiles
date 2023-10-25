return {
  {
    'willothy/flatten.nvim',
    dependencies = {
      {
        'willothy/wezterm.nvim',
        config = true,
      },
    },
    config = true,
    lazy = false,
    priority = 1001,
    -- opts = function()
    --   return {
    --     window = {
    --       open = 'alternate',
    --     },
    --     callbacks = {
    --       should_block = function(argv)
    --         -- Note that argv contains all the parts of the CLI command, including
    --         -- Neovim's path, commands, options and files.
    --         -- See: :help v:argv
    --
    --         -- In this case, we would block if we find the `-b` flag
    --         -- This allows you to use `nvim -b file1` instead of
    --         -- `nvim --cmd 'let g:flatten_wait=1' file1`
    --         return vim.tbl_contains(argv, '-b')
    --
    --         -- Alternatively, we can block if we find the diff-mode option
    --         -- return vim.tbl_contains(argv, "-d")
    --       end,
    --       post_open = function(bufnr, winnr, ft)
    --         -- If it's a normal file, just switch to its window
    --         vim.api.nvim_set_current_win(winnr)
    --
    --         -- If we're in a different wezterm pane/tab, switch to the current one
    --         -- Requires willothy/wezterm.nvim
    --         require('wezterm').switch_pane.id(tonumber(os.getenv 'WEZTERM_PANE'))
    --
    --         -- If the file is a git commit, create one-shot autocmd to delete its buffer on write
    --         -- If you just want the toggleable terminal integration, ignore this bit
    --         if ft == 'gitcommit' or ft == 'gitrebase' then
    --           vim.api.nvim_create_autocmd('BufWritePost', {
    --             buffer = bufnr,
    --             once = true,
    --             callback = vim.schedule_wrap(function()
    --               vim.api.nvim_buf_delete(bufnr, {})
    --             end),
    --           })
    --         end
    --       end,
    --     },
    --   }
    -- end,
  },
}
