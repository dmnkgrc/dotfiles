local M = {}

function M.setup()
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
      /:::/____/   \:::\ ___\  /:::/   |::::::::\    \  /:::/   |::|   |/\    \  /:::/\:::::::::::\    \
     /:::/\    \     \:::|    |/:::/    |:::::::::\____\/:: /    |::|   /::\____\/:::/  |:::::::::::\____\
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

	local center = {
		{
			action = function()
				require("snacks").picker.files()
			end,
			desc = " Find file",
			icon = " ",
			key = "f",
		},
		{ action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
		{
			action = function()
				require("snacks").picker.recent()
			end,
			desc = " Recent files",
			icon = " ",
			key = "r",
		},
		{
			action = function()
				require("snacks").picker.grep()
			end,
			desc = " Find text",
			icon = " ",
			key = "g",
		},
		{
			action = function()
				vim.pack.update()
			end,
			desc = " Plugins (vim.pack)",
			icon = "󰒲 ",
			key = "l",
		},
		{ action = "qa", desc = " Quit", icon = " ", key = "q" },
	}

	for _, button in ipairs(center) do
		button.desc = button.desc .. string.rep(" ", 35 - #button.desc)
		button.key_format = "  %s"
	end

	require("dashboard").setup({
		theme = "doom",
		hide = {
			statusline = false,
		},
		config = {
			header = vim.split(logo, "\n"),
			center = center,
			footer = function()
				local v = vim.version()
				return { "Neovim " .. tostring(v.major) .. "." .. tostring(v.minor) .. "." .. tostring(v.patch) }
			end,
		},
	})

	require("ibl").setup({})

	require("nvim-highlight-colors").setup({
		render = "background",
		virtual_symbol = "■",
		virtual_symbol_prefix = "",
		virtual_symbol_suffix = " ",
		virtual_symbol_position = "inline",
		enable_hex = true,
		enable_short_hex = true,
		enable_rgb = true,
		enable_hsl = true,
		enable_var_usage = true,
		enable_named_colors = true,
		enable_tailwind = false,
		custom_colors = nil,
		exclude_filetypes = {},
		exclude_buftypes = {},
	})
end

return M
