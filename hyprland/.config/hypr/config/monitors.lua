-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Default for other outputs: native/preferred resolution and 100% scaling.
hl.monitor({
    output    = "",
    mode      = "preferred",
    position  = "auto",
    scale     = 1,
    transform = 0,
})

-- Known laptop/PC layouts; an optional local HyprMon file still loads last.
for _, monitor in ipairs(MONITOR_PROFILE.monitors) do
    hl.monitor(monitor)
end
