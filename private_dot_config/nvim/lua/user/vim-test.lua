local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap
local g = vim.g

keymap("n", "<A-t>", ":TestNearest<CR>", opts)
keymap("n", "<A-T>", ":TestFile<CR>", opts)
keymap("n", "<A-a>", ":TestSuite<CR>", opts)
keymap("n", "<A-l>", ":TestLast<CR>", opts)
keymap("n", "<A-g>", ":TestVisit<CR>", opts)

g["test#strategy"] = "vimux"
g["test#preserve_screen"] = 0
g.VimuxOrientation = "h"
g.VimuxHeight = "30"
