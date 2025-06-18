local keymap = vim.keymap

keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

keymap.set('v', '<', '<gv')
keymap.set('v', '>', '>gv')