--- Hyprland Window and Layer Rules
--- Configured according to Hyprland 0.56+ Lua API
---@module 'hl'

-- ==========================================
-- WINDOW RULES
-- ==========================================

hl.window_rule({
    name  = "float_pavucontrol",
    match = { class = "^(pavucontrol)$" },
    float = true,
})

hl.window_rule({
    name  = "float_blueman",
    match = { class = "^(blueman-manager)$" },
    float = true,
})

hl.window_rule({
    name  = "float_nm_connection_editor",
    match = { class = "^(nm-connection-editor)$" },
    float = true,
})

hl.window_rule({
    name   = "float_copyq",
    match  = { class = "^(copyq)$" },
    float  = true,
    size   = { "50%", "50%" },
    center = true,
})

hl.window_rule({
    name  = "float_galculator",
    match = { class = "^(galculator)$" },
    float = true,
})

hl.window_rule({
    name  = "float_qalculate",
    match = { class = "^(qalculate-gtk)$" },
    float = true,
})

hl.window_rule({
    name  = "float_dolphin_dialogs",
    match = {
        class = "^(org.kde.dolphin)$",
        title = "^(Progress Dialog|Copying.*|Properties|Propriedades).*$",
    },
    float = true,
})

hl.window_rule({
    name         = "steam_stayfocused",
    match        = {
        title = "^/.*",
        class = "^(steam)$",
    },
    stay_focused = true,
})

hl.window_rule({
    name   = "float_ai_scratchpad",
    match  = { class = "^(ai-scratchpad)$" },
    float  = true,
    size   = { "60%", "65%" },
    center = true,
})

hl.window_rule({
    name   = "float_cava",
    match  = { class = "^(cava-visualizer)$" },
    float  = true,
    size   = { "65%", "40%" },
    center = true,
})

hl.window_rule({
    name  = "firefox_tile",
    match = { class = "^(firefox)$" },
    tile  = true,
})

hl.window_rule({
    name     = "rounding_floating",
    match    = { float = true },
    rounding = 12,
})

hl.window_rule({
    name     = "jarvis_scratchpad",
    match    = { class = "^(jarvis-scratchpad)$" },
    float    = true,
    size     = { "65%", "65%" },
    center   = true,
    rounding = 16,
})

-- ==========================================
-- LAYER RULES
-- ==========================================

hl.layer_rule({
    name         = "swaync_effects",
    match        = { namespace = "swaync" },
    no_anim      = true,
    blur         = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    name         = "rofi_effects",
    match        = { namespace = "rofi" },
    animation    = "popin 80%",
    blur         = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    name         = "waybar_effects",
    match        = { namespace = "waybar" },
    blur         = true,
    ignore_alpha = 0.2,
})

hl.layer_rule({
    name         = "wlogout_effects",
    match        = { namespace = "logout_dialog" },
    blur         = true,
    ignore_alpha = 0.4,
})
