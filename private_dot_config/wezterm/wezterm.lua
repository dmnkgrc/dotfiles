-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

local fish_path = "/opt/homebrew/bin/fish"

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Settings
config.default_prog = { fish_path, "-l" }
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.font = wezterm.font("MonoLisa")
config.font_size = 14
config.hide_tab_bar_if_only_one_tab = true
-- config.window_background_opacity = 0.95
config.color_scheme = "Kanagawa (Gogh)"

-- Dim inactive panes
config.inactive_pane_hsb = {
	saturation = 0.24,
	brightness = 0.5,
}

config.keys = {
	{
		key = "]",
		mods = "CMD",
		action = act.DisableDefaultAssignment,
	},
	{
		key = "[",
		mods = "CMD",
		action = act.DisableDefaultAssignment,
	},
}

-- The rest of the logic makes sure that Wezterm opens maximized --
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- and finally, return the configuration to wezterm
return config
