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
	-- {
	-- 	"copilotlsp-nvim/copilot-lsp",
	-- 	event = "BufEnter",
	-- 	init = function()
	-- 		vim.g.copilot_nes_debounce = 250
	-- 		require("copilot-lsp").setup({})
	-- 		vim.lsp.enable("copilot_ls")
	-- 		vim.keymap.set("n", "<tab>", function()
	-- 			local bufnr = vim.api.nvim_get_current_buf()
	-- 			local state = vim.b[bufnr].nes_state
	-- 			if state then
	-- 				vim.schedule(function()
	-- 					local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
	-- 						or (
	-- 							require("copilot-lsp.nes").apply_pending_nes()
	-- 							and require("copilot-lsp.nes").walk_cursor_end_edit()
	-- 						)
	-- 				end)
	-- 				return ""
	-- 			else
	-- 				return "<C-i>"
	-- 			end
	-- 		end, { desc = "Accept Copilot NES suggestion", expr = true })
	-- 		vim.keymap.set("n", "<esc>", function()
	-- 			---@diagnostic disable-next-line: empty-block
	-- 			if not require("copilot-lsp.nes").clear() then
	-- 				return "<esc>"
	-- 			end
	-- 			vim.keymap.set("n", "<leader>cr", function()
	-- 				require("copilot-lsp.nes").restore_suggestion()
	-- 				return nil
	-- 			end, { desc = "Restore previous Copilot suggestion", expr = true })
	-- 		end)
	-- 	end,
	-- },
	{
		"zbirenbaum/copilot.lua",
		-- requires = {
		--   "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
		-- },
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({})
		end,
	},
	{
		"sourcegraph/amp.nvim",
		branch = "main",
		lazy = false,
		opts = { auto_start = true, log_level = "info" },
	},
	{
		"folke/sidekick.nvim",
		lazy = false,
		opts = {
			cli = {
				mux = {
					backend = "tmux",
					enabled = false,
				},
			},
		},
		keys = {
			{
				"<tab>",
				function()
					-- if there is a next edit, jump to it, otherwise apply it if any
					if not require("sidekick").nes_jump_or_apply() then
						return "<Tab>" -- fallback to normal tab
					end
				end,
				expr = true,
				desc = "Goto/Apply Next Edit Suggestion",
			},
			{
				"<c-.>",
				function()
					require("sidekick.cli").focus()
				end,
				desc = "Sidekick Switch Focus",
				mode = { "n", "v" },
			},
			{
				"<leader>aa",
				function()
					require("sidekick.cli").toggle({ focus = true })
				end,
				desc = "Sidekick Toggle CLI",
				mode = { "n", "v" },
			},
			{
				"<leader>ac",
				function()
					require("sidekick.cli").toggle({ name = "claude", focus = true })
				end,
				desc = "Sidekick Claude Toggle",
				mode = { "n", "v" },
			},
			{
				"<leader>ao",
				function()
					require("sidekick.cli").toggle({ name = "opencode", focus = true })
				end,
				desc = "Sidekick Opencode Toggle",
				mode = { "n", "v" },
			},
			{
				"<leader>ax",
				function()
					require("sidekick.cli").toggle({ name = "codex", focus = true })
				end,
				desc = "Sidekick Codex Toggle",
				mode = { "n", "v" },
			},
			{
				"<leader>ap",
				function()
					require("sidekick.cli").select_prompt()
				end,
				desc = "Sidekick Ask Prompt",
				mode = { "n", "v" },
			},
		},
	},
	{
		"NickvanDyke/opencode.nvim",
		{ "folke/snacks.nvim", opts = { input = { enabled = true } } },
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
