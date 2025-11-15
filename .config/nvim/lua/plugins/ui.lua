return {
	-- Better UI for messages, cmdline and popupmenu
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},

	-- Dashboard
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		opts = function()
			local logo = [[
               _____                    _____                    _____                    _____
              /\    \                  /\    \                  /\    \                  /\    \
             /::\    \                /::\____\                /::\____\                /::\____\
            /::::\    \              /::::|   |               /::::|   |               /:::/    /
           /::::::\    \            /:::::|   |              /:::::|   |              /:::/    /
          /:::/\:::\    \          /::::::|   |             /::::::|   |             /:::/    /
         /:::/  \:::\    \        /:::/|::|   |            /:::/|::|   |            /:::/____/
        /:::/    \:::\    \      /:::/ |::|   |           /:::/ |::|   |           /::::\    \
       /:::/    / \:::\    \    /:::/  |::|___|______    /:::/  |::|   | _____    /::::::\____\________
      /:::/    /   \:::\ ___\  /:::/   |::::::::\    \  /:::/   |::|   |/\    \  /:::/\:::::::::::\    \
     /:::/____/     \:::|    |/:::/    |:::::::::\____\/:: /    |::|   /::\____\/:::/  |:::::::::::\____\
     \:::\    \     /:::|____|\::/    / ~~~~~/:::/    /\::/    /|::|  /:::/    /\::/   |::|~~~|~~~~~
      \:::\    \   /:::/    /  \/____/      /:::/    /  \/____/ |::| /:::/    /  \/____|::|   |
       \:::\    \ /:::/    /               /:::/    /           |::|/:::/    /         |::|   |
        \:::\    /:::/    /               /:::/    /            |::::::/    /          |::|   |
         \:::\  /:::/    /               /:::/    /             |:::::/    /           |::|   |
          \:::\/:::/    /               /:::/    /              |::::/    /            |::|   |
           \::::::/    /               /:::/    /               /:::/    /             |::|   |
            \::::/    /               /:::/    /               /:::/    /              \::|   |
             \::/____/                \::/    /                \::/    /                \:|   |
              ~~                       \/____/                  \/____/                  \|___|
      ]]

			logo = string.rep("\n", 8) .. logo .. "\n\n"

			local opts = {
				theme = "doom",
				hide = {
					statusline = false,
				},
				config = {
					header = vim.split(logo, "\n"),
					center = {
						{ action = "Telescope find_files", desc = " Find file", icon = " ", key = "f" },
						{ action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
						{ action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "r" },
						{ action = "Telescope live_grep", desc = " Find text", icon = " ", key = "g" },
						{ action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
						{ action = "qa", desc = " Quit", icon = " ", key = "q" },
					},
					footer = function()
						local stats = require("lazy").stats()
						local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
						return {
							"⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
						}
					end,
				},
			}

			for _, button in ipairs(opts.config.center) do
				button.desc = button.desc .. string.rep(" ", 35 - #button.desc)
				button.key_format = "  %s"
			end

			-- close Lazy and re-open when the dashboard is ready
			if vim.o.filetype == "lazy" then
				vim.cmd.close()
				vim.api.nvim_create_autocmd("User", {
					pattern = "DashboardLoaded",
					callback = function()
						require("lazy").show()
					end,
				})
			end

			return opts
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
	{
		"brenoprata10/nvim-highlight-colors",
		event = "VeryLazy",
		config = function()
			require("nvim-highlight-colors").setup({
				render = 'background',
				virtual_symbol = '■',
				virtual_symbol_prefix = '',
				virtual_symbol_suffix = ' ',
				virtual_symbol_position = 'inline',
				enable_hex = true,
				enable_short_hex = true,
				enable_rgb = true,
				enable_hsl = true,
				enable_var_usage = true,
				enable_named_colors = true,
				enable_tailwind = false,
				custom_colors = nil,
				exclude_filetypes = {},
				exclude_buftypes = {}
			})
		end,
	},
}
