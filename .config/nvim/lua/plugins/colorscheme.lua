return {
	{
		"oskarnurm/koda.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- vim.cmd("colorscheme koda")
		end,
	},
	-- {
	-- 	"nexxeln/vesper.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	-- config = function()
	-- 	-- 	vim.cmd.colorscheme("vesper")
	-- 	-- end,
	-- },
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			theme = "wave",
			background = {
				dark = "wave",
			},
			colors = {
				theme = {
					all = {
						ui = {
							bg_gutter = "none",
						},
					},
				},
			},
			overrides = function(colors)
				local theme = colors.theme
				return {
					NormalFloat = { bg = "none" },
					FloatBorder = { bg = "none" },
					FloatTitle = { bg = "none" },
					NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
					LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
					PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
					PmenuSbar = { bg = theme.ui.bg_m1 },
					PmenuThumb = { bg = theme.ui.bg_p2 },
				}
			end,
		},
		config = function()
			vim.cmd("colorscheme kanagawa")
		end,
	},
	-- {
	-- 	"webhooked/kanso.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		-- vim.cmd("colorscheme kanso-zen")
	-- 	end,
	-- },
	{
		dir = "~/dotfiles/themes/dracula-pro",
		name = "dracula-pro",
		lazy = false,
		priority = 1000,
		config = function()
			-- vim.cmd("colorscheme dracula_pro_van_helsing")
		end,
	},
}
