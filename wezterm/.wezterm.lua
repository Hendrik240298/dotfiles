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
config.send_composed_key_when_right_alt_is_pressed = false
config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  {
    key = 'h',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection('Left'),
  },
  {
    key = 'j',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection('Down'),
  },
  {
    key = 'k',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection('Up'),
  },
  {
    key = 'l',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection('Right'),
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = wezterm.action.ActivateKeyTable({ name = 'window', one_shot = true, timeout_milliseconds = 1000 }),
  },
  {
    key = 't',
    mods = 'LEADER',
    action = wezterm.action.ActivateKeyTable({ name = 'tab', one_shot = true, timeout_milliseconds = 1000 }),
  },
}

config.key_tables = {
  window = {
    {
      key = 'v',
      action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
    },
    {
      key = 's',
      action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }),
    },
    {
      key = 'd',
      action = wezterm.action.CloseCurrentPane({ confirm = true }),
    },
  },
  tab = {
    {
      key = 'n',
      action = wezterm.action.SpawnTab('CurrentPaneDomain'),
    },
    {
      key = 'd',
      action = wezterm.action.CloseCurrentTab({ confirm = true }),
    },
    {
      key = 'l',
      action = wezterm.action.ActivateTabRelative(1),
    },
    {
      key = 'h',
      action = wezterm.action.ActivateTabRelative(-1),
    },
    {
      key = '1',
      action = wezterm.action.ActivateTab(0),
    },
    {
      key = '2',
      action = wezterm.action.ActivateTab(1),
    },
    {
      key = '3',
      action = wezterm.action.ActivateTab(2),
    },
    {
      key = '4',
      action = wezterm.action.ActivateTab(3),
    },
    {
      key = '5',
      action = wezterm.action.ActivateTab(4),
    },
    {
      key = '6',
      action = wezterm.action.ActivateTab(5),
    },
    {
      key = '7',
      action = wezterm.action.ActivateTab(6),
    },
    {
      key = '8',
      action = wezterm.action.ActivateTab(7),
    },
    {
      key = '9',
      action = wezterm.action.ActivateTab(8),
    },
  },
}

table.insert(config.keys, {
  key = '5',
  mods = 'CTRL|SHIFT|ALT',
  action = wezterm.action.DisableDefaultAssignment,
})
table.insert(config.keys, {
  key = '2',
  mods = 'CTRL|SHIFT|ALT',
  action = wezterm.action.DisableDefaultAssignment,
})
table.insert(config.keys, {
  key = '%',
  mods = 'CTRL|ALT',
  action = wezterm.action.DisableDefaultAssignment,
})
table.insert(config.keys, {
  key = '%',
  mods = 'CTRL|SHIFT|ALT',
  action = wezterm.action.DisableDefaultAssignment,
})
table.insert(config.keys, {
  key = '"',
  mods = 'CTRL|ALT',
  action = wezterm.action.DisableDefaultAssignment,
})
table.insert(config.keys, {
  key = '"',
  mods = 'CTRL|SHIFT|ALT',
  action = wezterm.action.DisableDefaultAssignment,
})
table.insert(config.keys, {
  key = "'",
  mods = 'CTRL|SHIFT|ALT',
  action = wezterm.action.DisableDefaultAssignment,
})

-- Finally, return the configuration to wezterm:
return config
