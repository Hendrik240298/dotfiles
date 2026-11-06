-- Shared layouts, not a laptop's current settings copied onto every machine.
local profiles = {
    laptop = {
        name = "laptop", primary = "eDP-1", secondary = "", workspace_count = 9,
        monitors = {
            { output = "eDP-1", mode = "1920x1080@60.03", position = "0x0", scale = 1, transform = 0 },
        },
    },
    desktop = {
        name = "desktop", primary = "HDMI-A-1", secondary = "DP-1", workspace_count = 8,
        monitors = {
            { output = "HDMI-A-1", mode = "preferred", position = "1440x560", scale = 1.5, transform = 0 },
            { output = "DP-1", mode = "preferred", position = "0x0", scale = 1.5, transform = 3 },
        },
    },
    fallback = { name = "fallback", primary = "", secondary = "", workspace_count = 9, monitors = {} },
}

local function for_outputs(connected, preference)
    -- An optional machine-local preference resolves docked/mixed-output setups.
    -- Never pin workspaces to absent connectors, even with an explicit preference.
    if preference ~= "desktop" and connected["eDP-1"] then
        return profiles.laptop
    elseif preference ~= "laptop" and connected["HDMI-A-1"] and connected["DP-1"] then
        return profiles.desktop
    end
    return profiles.fallback
end

local function current()
    local preference
    local selector = io.open(os.getenv("HOME") .. "/.config/hypr/machine", "r")
    if selector then
        preference = selector:read("*l")
        selector:close()
        assert(preference == "desktop" or preference == "laptop" or preference == "auto",
               "~/.config/hypr/machine must contain desktop, laptop or auto")
    end

    local connected = {}
    -- Only read sysfs: never call synchronous hyprctl IPC while loading config.
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
    return for_outputs(connected, preference)
end

return { current = current, for_outputs = for_outputs }
