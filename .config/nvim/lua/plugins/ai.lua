return {
	-- {
	-- 	"milanglacier/minuet-ai.nvim",
	-- 	lazy = false,
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	config = function()
	-- 		require("minuet").setup({
	-- 			provider = "openai_compatible",
	-- 			throttle = 1000,
	-- 			debounce = 400,
	-- 			provider_options = {
	-- 				codestral = {
	-- 					api_key = "CODESTRAL_API_KEY",
	-- 					optional = {
	-- 						max_tokens = 64,
	-- 						temperature = 0,
	-- 						stop = { "\n\n" },
	-- 					},
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },
	{
		"copilotlsp-nvim/copilot-lsp",
		event = "BufEnter",
		init = function()
			vim.g.copilot_nes_debounce = 250
			require("copilot-lsp").setup({})
			vim.lsp.enable("copilot_ls")
			vim.keymap.set("n", "<tab>", function()
				local bufnr = vim.api.nvim_get_current_buf()
				local state = vim.b[bufnr].nes_state
				if state then
					vim.schedule(function()
						local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
							or (
								require("copilot-lsp.nes").apply_pending_nes()
								and require("copilot-lsp.nes").walk_cursor_end_edit()
							)
					end)
					return ""
				else
					return "<C-i>"
				end
			end, { desc = "Accept Copilot NES suggestion", expr = true })
			vim.keymap.set("n", "<esc>", function()
				---@diagnostic disable-next-line: empty-block
				if not require("copilot-lsp.nes").clear() then
					return "<esc>"
				end
				vim.keymap.set("n", "<leader>cr", function()
					require("copilot-lsp.nes").restore_suggestion()
					return nil
				end, { desc = "Restore previous Copilot suggestion", expr = true })
			end)
		end,
	},

	{
		"NickvanDyke/opencode.nvim",
		{ "folke/snacks.nvim", opts = { input = { enabled = true } } },
		---@type opencode.Config
		config = function()
			vim.opt.autoread = true
		end,
		keys = {
			{
				"<leader>ot",
				function()
					require("opencode").toggle()
				end,
				desc = "Toggle embedded opencode",
			},
			{
				"<leader>oa",
				function()
					require("opencode").ask()
				end,
				desc = "Ask opencode",
				mode = "n",
			},
			{
				"<leader>oa",
				function()
					require("opencode").ask("@selection: ")
				end,
				desc = "Ask opencode about selection",
				mode = "v",
			},
			{
				"<leader>op",
				function()
					require("opencode").select()
				end,
				desc = "Select prompt",
				mode = { "n", "v" },
			},
			{
				"<leader>on",
				function()
					require("opencode").command("session_new")
				end,
				desc = "New session",
			},
			{
				"<leader>oy",
				function()
					require("opencode").command("messages_copy")
				end,
				desc = "Copy last message",
			},
			{
				"<S-C-u>",
				function()
					require("opencode").command("messages_half_page_up")
				end,
				desc = "Scroll messages up",
			},
			{
				"<S-C-d>",
				function()
					require("opencode").command("messages_half_page_down")
				end,
				desc = "Scroll messages down",
			},
		},
	},
}
