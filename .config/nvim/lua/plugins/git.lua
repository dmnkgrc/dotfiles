local M = {}

function M.setup()
	require("gitsigns").setup({
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
	})

	local diffview_configured = false
	local function load_diffview()
		vim.cmd.packadd("diffview.nvim")
		if not diffview_configured then
			require("diffview").setup()
			diffview_configured = true
		end
	end

	vim.keymap.set("n", "<leader>gd", function()
		load_diffview()
		vim.cmd("DiffviewOpen")
	end, { desc = "DiffView" })
	vim.keymap.set("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git status" })
end

return M
