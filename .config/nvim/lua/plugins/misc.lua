return {
  { 'mistricky/codesnap.nvim', build = 'make', even = 'VeryLazy' },
  {
    'max397574/better-escape.nvim',
    config = true,
    opts = {
      mapping = { 'jk', 'jj' },
    },
  },
}
