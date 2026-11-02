-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Add your workspace rules here. Increment the workspace number as you go. Do not have duplicate workspaces.
for i = 1, NUM_WPM do
    local monitor = MONITOR1
    if i == 9 and MONITOR2 ~= "" then
        monitor = MONITOR2
    end
    hl.workspace_rule({ workspace = tostring(i), monitor = monitor, default = i == 1 or (i == 9 and MONITOR2 ~= ""), persistent = true })
end

-- For other layouts such as scrolling, see example below
-- hl.workspace_rule({ workspace = "1", monitor = MONITOR1, default = true, persistent = true, layout = "scrolling" })
