-- Firmware-mapped keyboards (Q11) must receive plain US on BOTH machines.

hl.config({
    input = {
        accel_profile = "flat",
        kb_layout = "us,us",
        kb_variant = ",intl",
        kb_options = "compose:caps,grp:alt_altgr_toggle",
    },
    -- Uncomment the section below to enable software cursors; this can help with cursor display or behavior issues
    -- cursor = {
    --     no_hardware_cursors = 1,
    -- },
})

-- ThinkPad built-in keyboard only. Keep this independent of monitor detection:
-- docking a laptop or plugging in the Q11 must never change keyboard semantics.
-- Verify this device name with `hyprctl devices` on the laptop.
hl.device({
    name = "at-translated-set-2-keyboard",
    kb_layout = "us,us",
    kb_variant = "colemak,intl",
    kb_options = "compose:caps,grp:alt_altgr_toggle",
    resolve_binds_by_sym = true,
})

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down",       action = "close" })
hl.gesture({ fingers = 3, direction = "up",         action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "left",       action = "float" })
