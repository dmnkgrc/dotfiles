local M = {}

function M.setup()
	local configured = false
	local function load_grug_far()
		vim.cmd.packadd("grug-far.nvim")
		if not configured then
			require("grug-far").setup({ headerMaxWidth = 80 })
			configured = true
		end
		return require("grug-far")
	end

	vim.keymap.set({ "n", "v" }, "<leader>sr", function()
		local grug = load_grug_far()
		local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
		grug.open({
			transient = true,
			prefills = {
				filesFilter = ext and ext ~= "" and "*." .. ext or nil,
			},
		})
	end, { desc = "Search and Replace" })
end

return M
