local M = {}

function M.setup()
	require("neotest").setup({
		adapters = {
			require("neotest-jest")({
				jestCommand = "npm test --",
				jestConfigFile = "custom.jest.config.ts",
				env = { CI = true },
				cwd = function()
					return vim.fn.getcwd()
				end,
			}),
		},
		status = { virtual_text = true },
		output = { open_on_run = true },
	})

	vim.keymap.set("n", "<leader>tt", function()
		require("neotest").run.run(vim.fn.expand("%"))
	end, { desc = "Run File" })
	vim.keymap.set("n", "<leader>tT", function()
		require("neotest").run.run(vim.uv.cwd())
	end, { desc = "Run All Test Files" })
	vim.keymap.set("n", "<leader>tr", function()
		require("neotest").run.run()
	end, { desc = "Run Nearest" })
	vim.keymap.set("n", "<leader>ts", function()
		require("neotest").summary.toggle()
	end, { desc = "Toggle Summary" })
	vim.keymap.set("n", "<leader>to", function()
		require("neotest").output.open({ enter = true, auto_close = true })
	end, { desc = "Show Output" })
	vim.keymap.set("n", "<leader>tO", function()
		require("neotest").output_panel.toggle()
	end, { desc = "Toggle Output Panel" })
	vim.keymap.set("n", "<leader>tS", function()
		require("neotest").run.stop()
	end, { desc = "Stop" })
end

return M
