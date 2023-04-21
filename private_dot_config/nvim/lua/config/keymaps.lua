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

map("n", "<leader>tz", ":!zellij run -f -- pnpm test %<cr>", { desc = "Run test in a Zellij floating pane" })
map("n", "<C-h>", "<cmd>lua require'tmux'.move_left()<cr>", { desc = "Move Left" })
map("n", "<C-j>", "<cmd>lua require'tmux'.move_bottom()<cr>", { desc = "Move Bottom" })
map("n", "<C-k>", "<cmd>lua require'tmux'.move_top()<cr>", { desc = "Move Top" })
map("n", "<C-l>", "<cmd>lua require'tmux'.move_right()<cr>", { desc = "Move Right" })
