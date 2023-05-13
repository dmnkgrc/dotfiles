local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
map("n", "<A-h>", require("smart-splits").resize_left, { desc = "Resize Left" })
map("n", "<A-j>", require("smart-splits").resize_down, { desc = "Resize Down" })
map("n", "<A-k>", require("smart-splits").resize_up, { desc = "Resize Up" })
map("n", "<A-l>", require("smart-splits").resize_right, { desc = "Resize Right" })
-- moving between splits
map("n", "<C-h>", require("smart-splits").move_cursor_left, { desc = "Move Left" })
map("n", "<C-j>", require("smart-splits").move_cursor_down, { desc = "Move Down" })
map("n", "<C-k>", require("smart-splits").move_cursor_up, { desc = "Move Up" })
map("n", "<C-l>", require("smart-splits").move_cursor_right, { desc = "Move Right" })
-- swapping buffers between windows
map("n", "<leader><leader>h", require("smart-splits").swap_buf_left, { desc = "Swap Buffers Left" })
map("n", "<leader><leader>j", require("smart-splits").swap_buf_down, { desc = "Swap Buffers Down" })
map("n", "<leader><leader>k", require("smart-splits").swap_buf_up, { desc = "Swap Buffers Up" })
map("n", "<leader><leader>l", require("smart-splits").swap_buf_right, { desc = "Swap Buffers Right" })
