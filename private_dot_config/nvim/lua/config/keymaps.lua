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
vim.keymap.set({ "n", "o", "x" }, "w", function()
  require("spider").motion("w")
end, { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "e", function()
  require("spider").motion("e")
end, { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "b", function()
  require("spider").motion("b")
end, { desc = "Spider-b" })
vim.keymap.set({ "n", "o", "x" }, "ge", function()
  require("spider").motion("ge")
end, { desc = "Spider-ge" })
map("n", "<leader>tz", ":!zellij run -f -- pnpm test %<cr>", { desc = "Run test in a Zellij floating pane" })
