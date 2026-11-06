-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Unrecognised outputs remain usable; known geometry comes from the profile.
hl.monitor({
    output    = "",
    mode      = "preferred",
    position  = "auto",
    scale     = 1,
    transform = 0,
})

for _, monitor in ipairs(MONITOR_PROFILE.monitors) do
    hl.monitor(monitor)
end
