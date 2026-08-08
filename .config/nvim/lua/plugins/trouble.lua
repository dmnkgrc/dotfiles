local M = {}

function M.setup()
	local configured = false
	local function trouble()
		vim.cmd.packadd("trouble.nvim")
		local plugin = require("trouble")
		if not configured then
			plugin.setup({
				modes = {
					lsp = {
						win = { position = "right" },
					},
				},
			})
			configured = true
		end
		return plugin
	end

	local function trouble_command(command)
		trouble()
		vim.cmd(command)
	end

	vim.keymap.set("n", "<leader>xx", function()
		trouble_command("Trouble diagnostics toggle")
	end, { desc = "Diagnostics (Trouble)" })
	vim.keymap.set("n", "<leader>xX", function()
		trouble_command("Trouble diagnostics toggle filter.buf=0")
	end, { desc = "Buffer Diagnostics (Trouble)" })
	vim.keymap.set("n", "<leader>xs", function()
		trouble_command("Trouble symbols toggle")
	end, { desc = "Symbols (Trouble)" })
	vim.keymap.set("n", "<leader>xS", function()
		trouble_command("Trouble lsp toggle")
	end, { desc = "LSP references/definitions/... (Trouble)" })
	vim.keymap.set("n", "<leader>xL", function()
		trouble_command("Trouble loclist toggle")
	end, { desc = "Location List (Trouble)" })
	vim.keymap.set("n", "<leader>xQ", function()
		trouble_command("Trouble qflist toggle")
	end, { desc = "Quickfix List (Trouble)" })
	vim.keymap.set("n", "[q", function()
		local plugin = trouble()
		if plugin.is_open() then
			plugin.prev({ skip_groups = true, jump = true })
		else
			local ok, err = pcall(vim.cmd.cprev)
			if not ok then
				vim.notify(err, vim.log.levels.ERROR)
			end
		end
	end, { desc = "Previous Trouble/Quickfix Item" })
	vim.keymap.set("n", "]q", function()
		local plugin = trouble()
		if plugin.is_open() then
			plugin.next({ skip_groups = true, jump = true })
		else
			local ok, err = pcall(vim.cmd.cnext)
			if not ok then
				vim.notify(err, vim.log.levels.ERROR)
			end
		end
	end, { desc = "Next Trouble/Quickfix Item" })
end

return M
