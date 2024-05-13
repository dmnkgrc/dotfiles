local map = vim.keymap.set

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
