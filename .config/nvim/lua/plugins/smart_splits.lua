local M = {}

local is_herdr_session = vim.env.HERDR_ENV == "1"

local function set_navigation_keymaps(splits)
	vim.keymap.set("n", "<C-h>", splits.move_cursor_left, { desc = "Move to left split" })
	vim.keymap.set("n", "<C-j>", splits.move_cursor_down, { desc = "Move to below split" })
	vim.keymap.set("n", "<C-k>", splits.move_cursor_up, { desc = "Move to above split" })
	vim.keymap.set("n", "<C-l>", splits.move_cursor_right, { desc = "Move to right split" })
	vim.keymap.set("n", "<A-h>", splits.resize_left, { desc = "Resize split left" })
	vim.keymap.set("n", "<A-j>", splits.resize_down, { desc = "Resize split down" })
	vim.keymap.set("n", "<A-k>", splits.resize_up, { desc = "Resize split up" })
	vim.keymap.set("n", "<A-l>", splits.resize_right, { desc = "Resize split right" })
end

function M.setup()
	if is_herdr_session then
		local splits = require("herdr-splits")
		splits.setup({
			at_edge = "stop",
			neovim_amount = 3,
			move_cursor_same_row = false,
			auto_sync_herdr = true,
		})
		set_navigation_keymaps(splits)
		return
	end

	local splits = require("smart-splits")
	splits.setup({
		ignored_filetypes = { "nofile", "quickfix", "prompt" },
		default_amount = 3,
		at_edge = "stop",
		resize_mode = {
			quit_key = "<ESC>",
			resize_keys = { "h", "j", "k", "l" },
			silent = false,
		},
		ignored_buftypes = { "NvimTree" },
		move_cursor_same_row = false,
		log_level = "info",
	})
	set_navigation_keymaps(splits)

	vim.keymap.set("n", "<leader>wh", splits.swap_buf_left, { desc = "Swap buffer left" })
	vim.keymap.set("n", "<leader>wj", splits.swap_buf_down, { desc = "Swap buffer down" })
	vim.keymap.set("n", "<leader>wk", splits.swap_buf_up, { desc = "Swap buffer up" })
	vim.keymap.set("n", "<leader>wl", splits.swap_buf_right, { desc = "Swap buffer right" })
	vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
	vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
	vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
	vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
end

return M
