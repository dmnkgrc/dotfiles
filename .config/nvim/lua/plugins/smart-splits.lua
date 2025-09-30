return {
	-- Smart splits
	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		keys = {
			-- Moving between splits
			{
				"<C-h>",
				function()
					require("smart-splits").move_cursor_left()
				end,
				desc = "Move to left split",
			},
			{
				"<C-j>",
				function()
					require("smart-splits").move_cursor_down()
				end,
				desc = "Move to below split",
			},
			{
				"<C-k>",
				function()
					require("smart-splits").move_cursor_up()
				end,
				desc = "Move to above split",
			},
			{
				"<C-l>",
				function()
					require("smart-splits").move_cursor_right()
				end,
				desc = "Move to right split",
			},
			-- Resizing splits
			{
				"<A-h>",
				function()
					require("smart-splits").resize_left()
				end,
				desc = "Resize split left",
			},
			{
				"<A-j>",
				function()
					require("smart-splits").resize_down()
				end,
				desc = "Resize split down",
			},
			{
				"<A-k>",
				function()
					require("smart-splits").resize_up()
				end,
				desc = "Resize split up",
			},
			{
				"<A-l>",
				function()
					require("smart-splits").resize_right()
				end,
				desc = "Resize split right",
			},
			-- Swapping buffers between windows
			{
				"<leader>wh",
				function()
					require("smart-splits").swap_buf_left()
				end,
				desc = "Swap buffer left",
			},
			{
				"<leader>wj",
				function()
					require("smart-splits").swap_buf_down()
				end,
				desc = "Swap buffer down",
			},
			{
				"<leader>wk",
				function()
					require("smart-splits").swap_buf_up()
				end,
				desc = "Swap buffer up",
			},
			{
				"<leader>wl",
				function()
					require("smart-splits").swap_buf_right()
				end,
				desc = "Swap buffer right",
			},
			-- Window resize with Ctrl+Arrow keys
			{ "<C-Up>", "<cmd>resize +2<cr>", desc = "Increase window height" },
			{ "<C-Down>", "<cmd>resize -2<cr>", desc = "Decrease window height" },
			{ "<C-Left>", "<cmd>vertical resize -2<cr>", desc = "Decrease window width" },
			{ "<C-Right>", "<cmd>vertical resize +2<cr>", desc = "Increase window width" },
		},
		opts = {
			ignored_filetypes = { "nofile", "quickfix", "prompt" },
			default_amount = 3,
			at_edge = "wrap",
			resize_mode = {
				quit_key = "<ESC>",
				resize_keys = { "h", "j", "k", "l" },
				silent = false,
			},
			ignored_buftypes = { "NvimTree" },
			move_cursor_same_row = false,
			log_level = "info",
		},
	},
}

