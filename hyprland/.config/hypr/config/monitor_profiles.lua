-- Shared display profiles. Detect connectors through sysfs, which is available
-- even during startup before Hyprland has created its monitor objects.
local profiles = {
    laptop = {
        primary = "eDP-1",
        secondary = "",
        monitors = {
            { output = "eDP-1", mode = "1920x1080@60.03", position = "0x0", scale = 1, transform = 0 },
        },
    },
    desktop = {
        primary = "HDMI-A-1",
        secondary = "DP-1",
        monitors = {
            { output = "HDMI-A-1", mode = "preferred", position = "1440x560", scale = 1.5, transform = 0 },
            { output = "DP-1", mode = "preferred", position = "0x0", scale = 1.5, transform = 3 },
        },
    },
    -- Unknown/single-monitor setups use the fallback rule, with no workspaces
    -- or application windows pinned to a connector that might not exist.
    fallback = { secondary = "", monitors = {} },
}

local function for_outputs(connected)
    if connected["eDP-1"] then
        return profiles.laptop
    elseif connected["HDMI-A-1"] and connected["DP-1"] then
        return profiles.desktop
    end
    return profiles.fallback
end

local function current()
    local connected = {}
    -- Do not query hyprctl from inside config loading: synchronous IPC can
    -- block the compositor that is currently executing this Lua code.
    local paths = io.popen("printf '%s\\n' /sys/class/drm/card*-*/status")
    if paths then
        for path in paths:lines() do
            local status = io.open(path, "r")
            if status then
                local output = path:match("/card%d+%-(.-)/status$")
                if output and status:read("*l") == "connected" then
                    connected[output] = true
                end
                status:close()
            end
        end
        paths:close()
    end
    return for_outputs(connected)
end

return { current = current, for_outputs = for_outputs }
