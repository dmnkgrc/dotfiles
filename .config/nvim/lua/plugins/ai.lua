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
				tools = {
					amp = {
						cmd = { "amp" },
						format = function(text)
							local Text = require("sidekick.text")
							Text.transform(text, function(str)
								return str:find("[^%w/_%.%-]") and ('"' .. str .. '"') or str
							end, "SidekickLocFile")
							local ret = Text.to_string(text)
							-- transform line ranges to a format that amp understands
							ret = ret:gsub("@([^ ]+)%s*:L(%d+):C%d+%-L(%d+):C%d+", "@%1#L%2-%3") -- @file :L5:C20-L6:C8 => @file#L5-6
							ret = ret:gsub("@([^ ]+)%s*:L(%d+):C%d+%-C%d+", "@%1#L%2") -- @file :L5:C9-C29 => @file#L5
							ret = ret:gsub("@([^ ]+)%s*:L(%d+)%-L(%d+)", "@%1#L%2-%3") -- @file :L5-L13 => @file#L5-13
							ret = ret:gsub("@([^ ]+)%s*:L(%d+):C%d+", "@%1#L%2") -- @file :L5:C9 => @file#L5
							ret = ret:gsub("@([^ ]+)%s*:L(%d+)", "@%1#L%2") -- @file :L5 => @file#L5
							return ret
						end,
					},
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
				"<leader>at",
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
				"<leader>aa",
				function()
					require("sidekick.cli").toggle({ name = "amp", focus = true })
				end,
				desc = "Sidekick Amp Toggle",
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
}
