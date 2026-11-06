-- Hyprland default apps

TERMINAL     = "ghostty"
FILE_MANAGER = "nautilus"
BROWSER      = "brave"
EDITOR       = "ghostty -e nvim"
CALCULATOR   = "gnome-calculator"

-- Shared apps; output placement and workspace counts belong to a profile.
MONITOR_PROFILE = require("config.monitor_profiles").current()
MONITOR1 = MONITOR_PROFILE.primary
MONITOR2 = MONITOR_PROFILE.secondary
MONITOR3 = ""
PRIMARY_MONITOR = MONITOR1

-- Workspaces
NUM_WPM = MONITOR_PROFILE.workspace_count -- Desktop: 1–8 primary, 9 portrait.
