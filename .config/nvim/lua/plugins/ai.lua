return {
  {
    'supermaven-inc/supermaven-nvim',
    event = 'VeryLazy',
    opts = {
      keymaps = {
        accept_suggestion = '<A-f>',
        clear_suggestion = '<A-c>',
        accept_word = '<A-w>',
      },
      -- disable_inline_completion = true,
      color = {
        suggestion_color = '#c4a7e7',
      },
    },
  },
}
