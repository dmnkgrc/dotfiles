-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.keys = {
  {
    key = ']',
    mods = 'CMD',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = '[',
    mods = 'CMD',
    action = wezterm.action.DisableDefaultAssignment,
  },
}

config.font = wezterm.font("Berkeley Mono Variable")
config.font_size = 15
config.hide_tab_bar_if_only_one_tab = true
-- config.window_background_opacity = 0.95

config.color_scheme = "Night Owl (Gogh)"

-- The rest of the logic makes sure that Wezterm opens maximized --

local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- and finally, return the configuration to wezterm
return config
