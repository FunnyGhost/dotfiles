-- pull in the wezterm API
local wezterm = require("wezterm")
local helpers = require("helpers")

-- this will hold the configuration
local config = wezterm.config_builder()
local act = wezterm.action

-- this is where you actually apply your config choices
config.font = wezterm.font_with_fallback({
	{ family = "Mononoki" },
})
config.font_size = 16

config.line_height = 1.2

-- changing the color scheme looks like this
config.color_scheme = "Eldritch"

-- window stuff
config.window_decorations = "RESIZE"
config.scrollback_lines = 3500
config.inactive_pane_hsb = {
	saturation = 0.24,
	brightness = 0.5,
}
config.use_fancy_tab_bar = false
config.status_update_interval = 1000

-- keys
config.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Disabled stuff
	{ key = "Enter", mods = "ALT", action = act.DisableDefaultAssignment },
	-- Pane keybindings
	{ key = "h", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "m", mods = "LEADER", action = act.TogglePaneZoomState },
	-- Integration with neovim panes
	{ key = "h", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-left") },
	{ key = "j", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-down") },
	{ key = "k", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-up") },
	{ key = "l", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-right") },
	-- Tab keybindings
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "n", mods = "LEADER", action = act.ShowTabNavigator },
	{
		key = "r",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Renaming Tab Title...:" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

return config
