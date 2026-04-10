local M = {}

function M.setup()
	require("smart-splits").setup({
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

	vim.keymap.set("n", "<C-h>", function()
		require("smart-splits").move_cursor_left()
	end, { desc = "Move to left split" })
	vim.keymap.set("n", "<C-j>", function()
		require("smart-splits").move_cursor_down()
	end, { desc = "Move to below split" })
	vim.keymap.set("n", "<C-k>", function()
		require("smart-splits").move_cursor_up()
	end, { desc = "Move to above split" })
	vim.keymap.set("n", "<C-l>", function()
		require("smart-splits").move_cursor_right()
	end, { desc = "Move to right split" })
	vim.keymap.set("n", "<A-h>", function()
		require("smart-splits").resize_left()
	end, { desc = "Resize split left" })
	vim.keymap.set("n", "<A-j>", function()
		require("smart-splits").resize_down()
	end, { desc = "Resize split down" })
	vim.keymap.set("n", "<A-k>", function()
		require("smart-splits").resize_up()
	end, { desc = "Resize split up" })
	vim.keymap.set("n", "<A-l>", function()
		require("smart-splits").resize_right()
	end, { desc = "Resize split right" })
	vim.keymap.set("n", "<leader>wh", function()
		require("smart-splits").swap_buf_left()
	end, { desc = "Swap buffer left" })
	vim.keymap.set("n", "<leader>wj", function()
		require("smart-splits").swap_buf_down()
	end, { desc = "Swap buffer down" })
	vim.keymap.set("n", "<leader>wk", function()
		require("smart-splits").swap_buf_up()
	end, { desc = "Swap buffer up" })
	vim.keymap.set("n", "<leader>wl", function()
		require("smart-splits").swap_buf_right()
	end, { desc = "Swap buffer right" })
	vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
	vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
	vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
	vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
end

return M
