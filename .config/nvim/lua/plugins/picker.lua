return {
	{
		"dmtrKovalenko/fff.nvim",
		build = "cargo build --release",
		-- or if you are using nixos
		-- build = "nix run .#release",
		opts = {
			-- pass here all the options
		},
		keys = {
			{
				"ff",
				function()
					require("fff").find_files()
				end,
				desc = "Open file picker",
			},
			{
				"<leader><space>",
				function()
					require("fff").find_files()
				end,
				desc = "Find Files (Root Dir)",
			},

			{
				"<leader>fg",
				function()
					require("fff").find_in_git_root()
				end,
				desc = "Find Files (git-files)",
			},
		},
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			quickfile = { enabled = true },
			picker = {
				enabled = true,
				sources = {
					files = {
						hidden = true,
					},
					grep = {
						hidden = true,
					},
				},
				win = {
					input = {
						keys = {
							["<a-c>"] = { "toggle_cwd", mode = { "i", "n" } },
						},
					},
				},
			},
		},
		keys = {
			-- General navigation
			{
				"<leader>,",
				function()
					require("snacks").picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>/",
				function()
					require("snacks").picker.grep()
				end,
				desc = "Grep (Root Dir)",
			},
			{
				"<leader>:",
				function()
					require("snacks").picker.command_history()
				end,
				desc = "Command History",
			},
			-- Find submenu
			{
				"<leader>fb",
				function()
					require("snacks").picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>fc",
				function()
					require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find Config File",
			},
			{
				"<leader>fr",
				function()
					require("snacks").picker.recent()
				end,
				desc = "Recent",
			},
			{
				"<leader>fR",
				function()
					require("snacks").picker.recent({ cwd = vim.fn.getcwd() })
				end,
				desc = "Recent (cwd)",
			},

			-- Git submenu
			{
				"<leader>gs",
				function()
					require("snacks").picker.git_status()
				end,
				desc = "Git Status",
			},
			{
				"<leader>gS",
				function()
					require("snacks").picker.git_stash()
				end,
				desc = "Git Stash",
			},

			-- Search/Grep submenu
			{
				'<leader>s"',
				function()
					require("snacks").picker.registers()
				end,
				desc = "Registers",
			},
			{
				"<leader>sa",
				function()
					require("snacks").picker.autocmds()
				end,
				desc = "Autocmds",
			},
			{
				"<leader>sb",
				function()
					require("snacks").picker.lines()
				end,
				desc = "Buffer Lines",
			},
			{
				"<leader>sB",
				function()
					require("snacks").picker.grep_buffers()
				end,
				desc = "Grep Open Buffers",
			},
			{
				"<leader>sc",
				function()
					require("snacks").picker.command_history()
				end,
				desc = "Command History",
			},
			{
				"<leader>sC",
				function()
					require("snacks").picker.commands()
				end,
				desc = "Commands",
			},
			{
				"<leader>sd",
				function()
					require("snacks").picker.diagnostics()
				end,
				desc = "[S]earch [D]iagnostics",
			},
			{
				"<leader>sD",
				function()
					require("snacks").picker.diagnostics({ buf = 0 })
				end,
				desc = "Buffer Diagnostics",
			},
			{
				"<leader>sg",
				function()
					require("snacks").picker.grep()
				end,
				desc = "[S]earch by [G]rep",
			},
			{
				"<leader>sG",
				function()
					require("snacks").picker.grep({ cwd = vim.fn.getcwd() })
				end,
				desc = "Grep (cwd)",
			},
			{
				"<leader>sh",
				function()
					require("snacks").picker.help()
				end,
				desc = "[S]earch [H]elp",
			},
			{
				"<leader>sH",
				function()
					require("snacks").picker.highlights()
				end,
				desc = "Highlights",
			},
			{
				"<leader>sj",
				function()
					require("snacks").picker.jumps()
				end,
				desc = "Jumps",
			},
			{
				"<leader>sk",
				function()
					require("snacks").picker.keymaps()
				end,
				desc = "[S]earch [K]eymaps",
			},
			{
				"<leader>sl",
				function()
					require("snacks").picker.loclist()
				end,
				desc = "Location List",
			},
			{
				"<leader>sM",
				function()
					require("snacks").picker.man()
				end,
				desc = "Man Pages",
			},
			{
				"<leader>sm",
				function()
					require("snacks").picker.marks()
				end,
				desc = "Marks",
			},
			{
				"<leader>sR",
				function()
					require("snacks").picker.resume()
				end,
				desc = "Resume",
			},
			{
				"<leader>sq",
				function()
					require("snacks").picker.qflist()
				end,
				desc = "Quickfix List",
			},
			{
				"<leader>sw",
				function()
					require("snacks").picker.grep_word()
				end,
				desc = "[S]earch current [W]ord",
			},
			{
				"<leader>sw",
				function()
					require("snacks").picker.grep_word()
				end,
				desc = "Visual selection (Root Dir)",
				mode = "v",
			},
			{
				"<leader>sW",
				function()
					require("snacks").picker.grep_word({ cwd = vim.fn.getcwd() })
				end,
				desc = "Word (cwd)",
			},
			{
				"<leader>sW",
				function()
					require("snacks").picker.grep_word({ cwd = vim.fn.getcwd() })
				end,
				desc = "Visual selection (cwd)",
				mode = "v",
			},
			{
				"<leader>s.",
				function()
					require("snacks").picker.resume()
				end,
				desc = "[S]earch Resume",
			},
			{
				"<leader>ss",
				function()
					require("snacks").picker.lsp_symbols()
				end,
				desc = "[S]earch LSP Symbols",
			},
			{
				"<leader>sS",
				function()
					require("snacks").picker.lsp_workspace_symbols()
				end,
				desc = "LSP Workspace Symbols",
			},

			-- UI submenu
			{
				"<leader>uC",
				function()
					require("snacks").picker.colorschemes()
				end,
				desc = "Colorschemes",
			},

			-- Shortcut for searching Neovim configuration files
			{
				"<leader>sn",
				function()
					require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "[S]earch [N]eovim files",
			},

			-- Current buffer fuzzy find
			{
				"<leader>/",
				function()
					require("snacks").picker.lines()
				end,
				desc = "[/] Fuzzily search in current buffer",
			},

			-- Live grep in open files
			{
				"<leader>s/",
				function()
					require("snacks").picker.grep_buffers()
				end,
				desc = "[S]earch [/] in Open Files",
			},
		},
	},
}
