local function format_amp_like(text)
	local Text = require("sidekick.text")
	Text.transform(text, function(str)
		return str:find("[^%w/_%.%-]") and ('"' .. str .. '"') or str
	end, "SidekickLocFile")
	local ret = Text.to_string(text)
	ret = ret:gsub("@([^ ]+)%s*:L(%d+):C%d+%-L(%d+):C%d+", "@%1#L%2-%3")
	ret = ret:gsub("@([^ ]+)%s*:L(%d+):C%d+%-C%d+", "@%1#L%2")
	ret = ret:gsub("@([^ ]+)%s*:L(%d+)%-L(%d+)", "@%1#L%2-%3")
	ret = ret:gsub("@([^ ]+)%s*:L(%d+):C%d+", "@%1#L%2")
	ret = ret:gsub("@([^ ]+)%s*:L(%d+)", "@%1#L%2")
	return ret
end

local M = {}

function M.setup()
	require("amp").setup({ auto_start = true, log_level = "info" })

	require("sidekick").setup({
		cli = {
			mux = {
				backend = "tmux",
				enabled = false,
			},
			tools = {
				amp = {
					cmd = { "amp" },
					format = format_amp_like,
				},
				pi = {
					cmd = { "pi" },
					format = format_amp_like,
				},
			},
		},
	})

	vim.keymap.set("n", "<tab>", function()
		if not require("sidekick").nes_jump_or_apply() then
			return "<Tab>"
		end
	end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })

	vim.keymap.set({ "n", "v" }, "<c-.>", function()
		require("sidekick.cli").focus()
	end, { desc = "Sidekick Switch Focus" })

	vim.keymap.set({ "n", "v" }, "<leader>at", function()
		require("sidekick.cli").toggle({ focus = true })
	end, { desc = "Sidekick Toggle CLI" })

	vim.keymap.set({ "n", "v" }, "<leader>ac", function()
		require("sidekick.cli").toggle({ name = "claude", focus = true })
	end, { desc = "Sidekick Claude Toggle" })

	vim.keymap.set({ "n", "v" }, "<leader>ao", function()
		require("sidekick.cli").toggle({ name = "opencode", focus = true })
	end, { desc = "Sidekick Opencode Toggle" })

	vim.keymap.set({ "n", "v" }, "<leader>aa", function()
		require("sidekick.cli").toggle({ name = "amp", focus = true })
	end, { desc = "Sidekick Amp Toggle" })

	vim.keymap.set({ "n", "v" }, "<leader>ax", function()
		require("sidekick.cli").toggle({ name = "codex", focus = true })
	end, { desc = "Sidekick Codex Toggle" })

	vim.keymap.set({ "n", "v" }, "<leader>ai", function()
		require("sidekick.cli").toggle({ name = "pi", focus = true })
	end, { desc = "Sidekick Pi Toggle" })

	vim.keymap.set({ "n", "v" }, "<leader>ap", function()
		require("sidekick.cli").select_prompt()
	end, { desc = "Sidekick Ask Prompt" })
end

return M
