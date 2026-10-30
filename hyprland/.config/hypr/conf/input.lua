--- Hyprland Monitor, Input and Gesture Configuration
--- Configured according to Hyprland 0.56+ Lua API
---@module 'hl'

-- Monitor Configuration
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = 1,
})

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@60",
    position = "auto",
    scale    = 1,
})

-- Dynamic fallback for any additional external displays/projectors
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

-- Input & Keyboard Configuration
hl.config({
    input = {
        kb_layout            = "br,us",
        kb_variant           = "abnt2,intl",
        kb_model             = "abnt2",
        repeat_delay         = 300,
        repeat_rate          = 50,
        follow_mouse         = 1,
        sensitivity          = 0,
        accel_profile        = "flat",

        touchpad = {
            natural_scroll       = true,
            disable_while_typing = true,
            tap_to_click         = true,
            scroll_factor        = 0.5,
        },
    },

    cursor = {
        no_hardware_cursors = 1,
        no_warps            = true,
        inactive_timeout    = 5,
    },
})

-- Modern Touchpad Gestures (Swipe workspaces with 3 fingers)
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})
