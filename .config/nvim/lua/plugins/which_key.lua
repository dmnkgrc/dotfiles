local M = {}

function M.setup()
	require("which-key").setup({
		delay = 0,
		icons = {
			mappings = vim.g.have_nerd_font,
			keys = vim.g.have_nerd_font and {} or {
				Up = "<Up> ",
				Down = "<Down> ",
				Left = "<Left> ",
				Right = "<Right> ",
				C = "<C-…> ",
				M = "<M-…> ",
				D = "<D-…> ",
				S = "<S-…> ",
				CR = "<CR> ",
				Esc = "<Esc> ",
				ScrollWheelDown = "<ScrollWheelDown> ",
				ScrollWheelUp = "<ScrollWheelUp> ",
				NL = "<NL> ",
				BS = "<BS> ",
				Space = "<Space> ",
				Tab = "<Tab> ",
				F1 = "<F1>",
				F2 = "<F2>",
				F3 = "<F3>",
				F4 = "<F4>",
				F5 = "<F5>",
				F6 = "<F6>",
				F7 = "<F7>",
				F8 = "<F8>",
				F9 = "<F9>",
				F10 = "<F10>",
				F11 = "<F11>",
				F12 = "<F12>",
			},
		},
		spec = {
			{ "<leader>c", group = "Claude Code" },
			{ "<leader>f", group = "Find/File" },
			{ "<leader>g", group = "Git" },
			{ "<leader>s", group = "Search" },
			{ "<leader>t", group = "Test" },
			{ "<leader>u", group = "UI/Toggle" },
			{ "<leader>w", group = "Window" },
			{ "<leader>x", group = "Diagnostics/Quickfix" },
			{ "]", group = "Next" },
			{ "[", group = "Previous" },
			{ "g", group = "Goto" },
		},
	})

	vim.keymap.set("n", "<leader>l", function()
		vim.pack.update()
	end, { desc = "Plugins (vim.pack)" })
	vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
	vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
	vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
	vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
	vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
	vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
	vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
	vim.keymap.set("n", "<leader>uf", function()
		vim.g.autoformat = not vim.g.autoformat
		print("Autoformat " .. (vim.g.autoformat and "enabled" or "disabled"))
	end, { desc = "Toggle autoformat" })
	vim.keymap.set("n", "<leader>us", function()
		vim.opt.spell = not vim.opt.spell:get()
	end, { desc = "Toggle Spelling" })
	vim.keymap.set("n", "<leader>uw", function()
		vim.opt.wrap = not vim.opt.wrap:get()
	end, { desc = "Toggle Word Wrap" })
	vim.keymap.set("n", "<leader>uL", function()
		vim.opt.relativenumber = not vim.opt.relativenumber:get()
	end, { desc = "Toggle Relative Line Numbers" })
	vim.keymap.set("n", "<leader>ul", function()
		vim.opt.number = not vim.opt.number:get()
		vim.opt.relativenumber = not vim.opt.relativenumber:get()
	end, { desc = "Toggle Line Numbers" })
	vim.keymap.set("n", "<leader>ud", function()
		local cur = vim.diagnostic.is_enabled({ bufnr = 0 })
		vim.diagnostic.enable(not cur, { bufnr = 0 })
	end, { desc = "Toggle Diagnostics" })
	vim.keymap.set("n", "<leader>uc", function()
		vim.opt.conceallevel = vim.opt.conceallevel:get() == 0 and (vim.o.conceallevel > 0 and vim.o.conceallevel or 3) or 0
	end, { desc = "Toggle Conceal" })
	if vim.lsp.inlay_hint then
		vim.keymap.set("n", "<leader>uh", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, { desc = "Toggle Inlay Hints" })
	end
	vim.keymap.set("n", "<leader>uT", function()
		vim.opt.showtabline = vim.opt.showtabline:get() == 0 and 2 or 0
	end, { desc = "Toggle Tabline" })
	vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
	vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
	vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
	vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
	vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
	vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })
	vim.keymap.set("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw / clear hlsearch / diff update" })
	vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
	vim.keymap.set("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })
end

return M
