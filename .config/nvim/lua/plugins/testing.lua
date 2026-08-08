local M = {}

function M.setup()
	local configured = false
	local function neotest()
		vim.cmd.packadd("nvim-nio")
		vim.cmd.packadd("neotest")
		vim.cmd.packadd("neotest-jest")

		local test = require("neotest")
		if not configured then
			test.setup({
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
			configured = true
		end
		return test
	end

	vim.keymap.set("n", "<leader>tt", function()
		neotest().run.run(vim.fn.expand("%"))
	end, { desc = "Run File" })
	vim.keymap.set("n", "<leader>tT", function()
		neotest().run.run(vim.uv.cwd())
	end, { desc = "Run All Test Files" })
	vim.keymap.set("n", "<leader>tr", function()
		neotest().run.run()
	end, { desc = "Run Nearest" })
	vim.keymap.set("n", "<leader>ts", function()
		neotest().summary.toggle()
	end, { desc = "Toggle Summary" })
	vim.keymap.set("n", "<leader>to", function()
		neotest().output.open({ enter = true, auto_close = true })
	end, { desc = "Show Output" })
	vim.keymap.set("n", "<leader>tO", function()
		neotest().output_panel.toggle()
	end, { desc = "Toggle Output Panel" })
	vim.keymap.set("n", "<leader>tS", function()
		neotest().run.stop()
	end, { desc = "Stop" })
end

return M
