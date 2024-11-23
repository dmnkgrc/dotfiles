-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- vim.cmd [[
-- set runtimepath^=~/.vim runtimepath+=~/.vim/after
-- let &packpath = &runtimepath
-- ]]

require('lazy').setup({
  spec = {
    { import = 'plugins' },
  },
  checker = { enabled = true },
  dev = {
    ---@type string | fun(plugin: LazyPlugin): string directory where you store your local plugin projects
    path = '~/code/nvim',
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = {}, -- For example {"folke"}
    fallback = false, -- Fallback to git when local plugin doesn't exist
  },
  -- performance = {
  --   reset_packpath = false,
  -- },
}, {})

-- vim.cmd 'packloadall'
--
-- vim.cmd [[
--   syntax enable
--   let g:dracula_colorterm = 0
--   colorscheme dracula_pro
-- ]]
