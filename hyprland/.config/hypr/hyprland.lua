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

-- hyprmon: managed monitor profile include
-- Optional: a fresh installation need not have a HyprMon profile yet.
local hyprmon = io.open(os.getenv("HOME") .. "/.config/hypr/hyprmon.lua", "r")
if hyprmon then
    hyprmon:close()
    require("hyprmon")
end
