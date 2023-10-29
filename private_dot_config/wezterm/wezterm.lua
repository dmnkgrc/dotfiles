-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux

local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm/")

-- This table will hold the configuration.
local config = {
	-- window_background_opacity = 0.95,
	window_padding = {
		left = 0,
		right = 0,
	},
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
	-- font = wezterm.font("Berkeley Mono Variable"),
	font = wezterm.font("MonoLisa"),
	font_size = 14,
}

-- Leader is the same as my old tmux prefix
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = require("keybinds")

for _, value in ipairs(require("plugins.smart-splits").keys) do
	table.insert(config.keys, value)
end

local function mergeTables(t1, t2)
	for key, value in pairs(t2) do
		t1[key] = value
	end
end

local colors = require("colors")
mergeTables(config, colors)

wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

workspace_switcher.apply_to_config(config, "s", "LEADER", function(label)
	return wezterm.format({
		{ Text = "󱂬: " .. label },
	})
end)

-- and finally, return the configuration to wezterm
return config
