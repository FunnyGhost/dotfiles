-- pull in the wezterm API
local wezterm = require("wezterm")

-- this will hold the configuration
local config = wezterm.config_builder()

-- this is where you actually apply your config choices

-- changing the color scheme looks like this
config.color_scheme = "Eldritch"

return config
