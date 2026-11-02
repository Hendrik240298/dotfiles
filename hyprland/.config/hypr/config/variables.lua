-- Hyprland default apps

TERMINAL     = "ghostty"
FILE_MANAGER = "nautilus"
BROWSER      = "brave"
EDITOR       = "ghostty -e nvim"
CALCULATOR   = "gnome-calculator"

-- Select the laptop, dual-monitor PC or portable fallback profile on reload.
MONITOR_PROFILE = require("config.monitor_profiles").current()
MONITOR1 = MONITOR_PROFILE.primary
MONITOR2 = MONITOR_PROFILE.secondary
MONITOR3 = ""
PRIMARY_MONITOR = MONITOR1

-- Workspaces
NUM_WPM = 9 -- Same shortcuts on both machines; the PC keeps workspace 9 on DP-1.
