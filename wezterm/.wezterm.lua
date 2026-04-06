-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font = wezterm.font_with_fallback({
  'JetBrainsMono Nerd Font Mono',
  'JetBrains Mono',
})
config.font_size = 12
config.color_scheme = 'Tokyo Night'
config.window_decorations = 'RESIZE'
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.keys = {
  {
    key = '5',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
  },
  {
    key = '2',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }),
  },
}

-- Finally, return the configuration to wezterm:
return config
