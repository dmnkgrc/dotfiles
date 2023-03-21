-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font = wezterm.font 'Berkeley Mono'
config.font_size = 13

-- config.colors = require('lua/rose-pine').colors()
-- config.window_frame = require('lua/rose-pine').window_frame()
config.color_scheme = 'rose-pine'

-- and finally, return the configuration to wezterm
return config
