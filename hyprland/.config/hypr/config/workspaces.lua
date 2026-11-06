-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Add your workspace rules here. Increment the workspace number as you go. Do not have duplicate workspaces.
for i = 1, 9 do
    local monitor = i == 9 and MONITOR2 ~= "" and MONITOR2 or MONITOR1
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = monitor ~= "" and monitor or nil,
        default = MONITOR_PROFILE.name == "desktop" or i == 1,
        persistent = true,
    })
end

-- For other layouts such as scrolling, see example below
-- hl.workspace_rule({ workspace = "1", monitor = MONITOR1, default = true, persistent = true, layout = "scrolling" })
