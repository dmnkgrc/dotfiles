local opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- Keep cursor centered when scrolling
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)

-- Move selected line / block of text in visual mode
map('v', 'J', ":m '>+1<CR>gv=gv", opts)
map('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- Fast saving
map('n', '<leader>w', ':write!<CR>', opts)
map('n', '<leader>qq', ':q!<CR>', opts)

-- Remap for dealing with visual line wraps
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- paste over currently selected text without yanking it
map('v', 'p', '"_dp')
map('v', 'P', '"_dP')

-- copy everything between { and } including the brackets
-- p puts text after the cursor,
-- P puts text before the cursor.
map('n', 'YY', 'va{Vy', opts)

-- Move line on the screen rather than by line in the file
map('n', 'j', 'gj', opts)
map('n', 'k', 'gk', opts)

-- Map enter to ciw in normal mode
map('n', '<CR>', 'ciw', opts)
map('n', '<BS>', 'ci', opts)

vim.keymap.set('n', '<C-s>', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = 'Fuzzily search in current buffer' })

-- Split line with X
map('n', 'X', ':keeppatterns substitute/\\s*\\%#\\s*/\\r/e <bar> normal! ==^<cr>', { silent = true })

-- General
map('n', '<D-s>', ':w<CR>', { desc = 'Save file' })

-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
map('n', '<A-h>', "<cmd>lua require('smart-splits').resize_left()<cr>", { desc = 'Resize Left' })
map('n', '<A-j>', "<cmd>lua require('smart-splits').resize_down()<cr>", { desc = 'Resize Down' })
map('n', '<A-k>', "<cmd>lua require('smart-splits').resize_up()<cr>", { desc = 'Resize Up' })
map('n', '<A-l>', "<cmd>lua require('smart-splits').resize_right()<cr>", { desc = 'Resize Right' })
-- moving between splits
map('n', '<C-h>', "<cmd>lua require('smart-splits').move_cursor_left()<cr>", { desc = 'Move Left' })
map('n', '<C-j>', "<cmd>lua require('smart-splits').move_cursor_down()<cr>", { desc = 'Move Down' })
map('n', '<C-k>', "<cmd>lua require('smart-splits').move_cursor_up()<cr>", { desc = 'Move Up' })
map('n', '<C-l>', "<cmd>lua require('smart-splits').move_cursor_right()<cr>", { desc = 'Move Right' })
-- swapping buffers between windows
map('n', '<leader><C-h>', "<cmd>lua require('smart-splits').swap_buf_left()<cr>", { desc = 'Swap Buffers Left' })
map('n', '<leader><C-j>', "<cmd>lua require('smart-splits').swap_buf_down()<cr>", { desc = 'Swap Buffers Down' })
map('n', '<leader><C-k>', "<cmd>lua require('smart-splits').swap_buf_up()<cr>", { desc = 'Swap Buffers Up' })
map('n', '<leader><C-l>', "<cmd>lua require('smart-splits').swap_buf_right()<cr>", { desc = 'Swap Buffers Right' })
