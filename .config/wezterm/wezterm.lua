-- Pull in the wezterm API
local wezterm = require("wezterm")
local kanso_zen = require("kanso_zen")
local mux = wezterm.mux
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

-- This table will hold the configuration.
local config = {
	-- window_background_opacity = 0.95,
	hide_tab_bar_if_only_one_tab = true,
	hide_mouse_cursor_when_typing = false,
	inactive_pane_hsb = {
		saturation = 0.24,
		brightness = 0.5,
	},
	scrollback_lines = 20000,
	audible_bell = "Disabled",
	enable_scroll_bar = false,

	status_update_interval = 500,
	font = wezterm.font("Berkeley Mono Variable"),
	-- font = wezterm.font("MonoLisa"),
	font_size = 15,
	enable_csi_u_key_encoding = true,

	-- Performance optimizations
	front_end = "WebGpu",
	webgpu_power_preference = "HighPerformance",
	max_fps = 120,
	animation_fps = 60,
}

-- Merge kanso_zen theme into config
for k, v in pairs(kanso_zen) do
	config[k] = v
end

config.leader = { key = "a", mods = "CTRL" }

config.keys = require("keybinds")

workspace_switcher.apply_to_config(config)

smart_splits.apply_to_config(config)

-- config.color_scheme = "Dracula-Pro-Buffy"
-- config.color_scheme = "Kanagawa (Gogh)"

wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- and finally, return the configuration to wezterm
return config
