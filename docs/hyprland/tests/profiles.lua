-- Run from the repository root: lua docs/hyprland/tests/profiles.lua
local root = "hyprland/.config/hypr/"
package.path = root .. "?.lua;" .. package.path
local profiles = require("config.monitor_profiles")
local checks = 0
local function check(value, message)
    checks = checks + 1
    assert(value, message)
end

local function capture(profile)
    MONITOR_PROFILE = profile
    local calls = { configs = {}, devices = {}, monitors = {}, workspaces = {}, binds = {} }
    local function dispatcher(path)
        return setmetatable({}, {
            __index = function(_, key) return dispatcher(path .. "." .. key) end,
            __call = function(_, args) return { dispatcher = path, args = args } end,
        })
    end
    hl = {
        config = function(c) table.insert(calls.configs, c) end,
        device = function(c) table.insert(calls.devices, c) end,
        monitor = function(c) table.insert(calls.monitors, c) end,
        workspace_rule = function(c) table.insert(calls.workspaces, c) end,
        bind = function(key, action) calls.binds[key] = action end,
        gesture = function() end,
        dsp = dispatcher("dsp"),
    }
    -- variables.lua normally selects the profile. Keep this fixture independent
    -- of the host's connectors while testing its consumers with the real module.
    local original_current = profiles.current
    profiles.current = function() return profile end
    dofile(root .. "config/variables.lua")
    profiles.current = original_current
    for _, name in ipairs({ "inputs", "monitors", "workspaces", "binds" }) do
        dofile(root .. "config/" .. name .. ".lua")
    end
    return calls
end

local desktop = profiles.for_outputs({ ["HDMI-A-1"] = true, ["DP-1"] = true })
local laptop = profiles.for_outputs({ ["eDP-1"] = true })
local fallback = profiles.for_outputs({ ["HDMI-A-1"] = true })
check(desktop.name == "desktop", "dual-monitor desktop detection")
check(laptop.name == "laptop", "laptop detection")
check(fallback.name == "fallback", "disconnected desktop must use safe fallback")
check(profiles.for_outputs({ ["eDP-1"] = true, ["HDMI-A-1"] = true, ["DP-1"] = true }).name == "laptop", "auto laptop priority")
check(profiles.for_outputs({ ["eDP-1"] = true, ["HDMI-A-1"] = true, ["DP-1"] = true }, "desktop").name == "desktop", "explicit desktop selection")
check(profiles.for_outputs({ ["HDMI-A-1"] = true }, "desktop").name == "fallback", "explicit selection cannot pin absent outputs")
for _, profile in ipairs({ desktop, laptop, fallback }) do
    local calls = capture(profile)
    local input = calls.configs[1].input
    check(input.kb_variant == ",intl", profile.name .. ": global layout must never double-map firmware Colemak")
    check(#calls.devices == 1 and calls.devices[1].name == "at-translated-set-2-keyboard", "software Colemak restricted to built-in keyboard")
    check(calls.devices[1].kb_variant == "colemak,intl", "built-in keyboard keeps laptop Colemak")
    check(calls.devices[1].resolve_binds_by_sym == true, "built-in keyboard shortcuts follow Colemak symbols")
    check(#calls.workspaces == 9, profile.name .. ": exactly nine workspace rules")
    check(calls.binds["SUPER + 9"].args.workspace == 9, "workspace 9 focus retained")
    check(calls.binds["SUPER + SHIFT + 9"].args.workspace == 9, "workspace 9 move retained")
    check(calls.binds["SUPER + SHIFT + 3"].args.workspace == 3, "no empty-monitor binding may shadow workspace 3")
    if profile.name == "desktop" then
        check(NUM_WPM == 8, "desktop relative-workspace count retained")
        for i = 1, 8 do check(calls.workspaces[i].monitor == "HDMI-A-1", "desktop primary workspace " .. i) end
        check(calls.workspaces[9].monitor == "DP-1", "portrait workspace 9 retained")
        check(calls.monitors[2].position == "1440x560" and calls.monitors[2].scale == 1.5, "desktop landscape geometry retained")
        check(calls.monitors[3].transform == 3 and calls.monitors[3].scale == 1.5, "desktop portrait geometry retained")
    elseif profile.name == "laptop" then
        check(NUM_WPM == 9, "laptop has nine primary workspaces")
        for _, rule in ipairs(calls.workspaces) do check(rule.monitor == "eDP-1", "laptop workspace placement") end
        check(calls.monitors[2].mode == "1920x1080@60.03" and calls.monitors[2].scale == 1, "laptop geometry retained")
    else
        for _, rule in ipairs(calls.workspaces) do check(rule.monitor == nil, "fallback has no output pinning") end
    end
end
print(checks .. " profile checks passed")
