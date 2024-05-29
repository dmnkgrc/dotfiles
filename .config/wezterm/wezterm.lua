-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux

-- This table will hold the configuration.
local config = {
	-- window_background_opacity = 0.95,
	hide_tab_bar_if_only_one_tab = true,
	hide_mouse_cursor_when_typing = false,
	inactive_pane_hsb = {
		saturation = 0.24,
		brightness = 0.5,
	},
	scrollback_lines = 5000,
	audible_bell = "Disabled",
	enable_scroll_bar = true,

	status_update_interval = 1000,
	font = wezterm.font("MonoLisa"),
	font_size = 13,
}

config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = require("keybinds")

-- for _, value in ipairs(require("plugins.smart-splits").keys) do
-- 	table.insert(config.keys, value)
-- end

-- local function mergeTables(t1, t2)
-- 	for key, value in pairs(t2) do
-- 		t1[key] = value
-- 	end
-- end

config.color_scheme = "rose-pine-moon"
-- local colors = require("colors")
-- mergeTables(config, colors)

wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- and finally, return the configuration to wezterm
return config
