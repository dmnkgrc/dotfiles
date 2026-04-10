local M = {}

function M.setup()
	require("notify").setup({
		timeout = 3000,
		max_height = function()
			return math.floor(vim.o.lines * 0.75)
		end,
		max_width = function()
			return math.floor(vim.o.columns * 0.75)
		end,
	})

	require("noice").setup({
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		},
		routes = {
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "%d+L, %d+B" },
						{ find = "; after #%d+" },
						{ find = "; before #%d+" },
					},
				},
				view = "mini",
			},
		},
		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
			inc_rename = true,
			lsp_doc_border = false,
		},
	})

	vim.keymap.set("n", "<leader>sn", "", { desc = "+noice" })
	vim.keymap.set("c", "<S-Enter>", function()
		require("noice").redirect(vim.fn.getcmdline())
	end, { desc = "Redirect Cmdline" })
	vim.keymap.set("n", "<leader>snl", function()
		require("noice").cmd("last")
	end, { desc = "Noice Last Message" })
	vim.keymap.set("n", "<leader>snh", function()
		require("noice").cmd("history")
	end, { desc = "Noice History" })
	vim.keymap.set("n", "<leader>sna", function()
		require("noice").cmd("all")
	end, { desc = "Noice All" })
	vim.keymap.set("n", "<leader>snd", function()
		require("noice").cmd("dismiss")
	end, { desc = "Dismiss All" })
	vim.keymap.set("n", "<leader>snt", function()
		require("noice").cmd("pick")
	end, { desc = "Noice Picker" })
	vim.keymap.set({ "i", "n", "s" }, "<c-f>", function()
		if not require("noice.lsp").scroll(4) then
			return "<c-f>"
		end
	end, { silent = true, expr = true, desc = "Scroll Forward" })
	vim.keymap.set({ "i", "n", "s" }, "<c-b>", function()
		if not require("noice.lsp").scroll(-4) then
			return "<c-b>"
		end
	end, { silent = true, expr = true, desc = "Scroll Backward" })
end

return M
