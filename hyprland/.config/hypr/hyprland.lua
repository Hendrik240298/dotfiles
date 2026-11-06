-- CachyOS Hyprland Configuration

require("config.animations")
require("config.autostart")
require("config.colors")
require("config.decorations")
require("config.variables")
require("config.environment")
require("config.inputs")
require("config.binds")
require("config.misc")
require("config.monitors")
require("config.windowrules")
require("config.workspaces")

-- Preserve the laptop's optional HyprMon override, but do not activate an old
-- local monitor file on the desktop just because this shared config was pulled.
if MONITOR_PROFILE.name == "laptop" then
    local hyprmon = io.open(os.getenv("HOME") .. "/.config/hypr/hyprmon.lua", "r")
    if hyprmon then
        hyprmon:close()
        require("hyprmon")
    end
end
