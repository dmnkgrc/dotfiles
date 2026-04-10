local M = {}

function M.setup()
	require("trouble").setup({
		modes = {
			lsp = {
				win = { position = "right" },
			},
		},
	})

	vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
	vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
	vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols (Trouble)" })
	vim.keymap.set("n", "<leader>xS", "<cmd>Trouble lsp toggle<cr>", { desc = "LSP references/definitions/... (Trouble)" })
	vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
	vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
	vim.keymap.set("n", "[q", function()
		if require("trouble").is_open() then
			require("trouble").prev({ skip_groups = true, jump = true })
		else
			local ok, err = pcall(vim.cmd.cprev)
			if not ok then
				vim.notify(err, vim.log.levels.ERROR)
			end
		end
	end, { desc = "Previous Trouble/Quickfix Item" })
	vim.keymap.set("n", "]q", function()
		if require("trouble").is_open() then
			require("trouble").next({ skip_groups = true, jump = true })
		else
			local ok, err = pcall(vim.cmd.cnext)
			if not ok then
				vim.notify(err, vim.log.levels.ERROR)
			end
		end
	end, { desc = "Next Trouble/Quickfix Item" })
end

return M
