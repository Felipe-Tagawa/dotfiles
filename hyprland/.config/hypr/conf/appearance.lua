--- Hyprland Appearance, Decorations, and Animations
--- Configured according to Hyprland 0.56+ Lua API
---@module 'hl'

local ok, current_theme = pcall(require, "current_theme")
if not ok or not current_theme then
    local mocha = require("mocha")
    current_theme = {
        active_1 = mocha.mauve,
        active_2 = mocha.lavender,
        active_3 = mocha.sapphire,
        inactive = mocha.surface0,
        shadow = "0x88cba6f7",
        shadow_inactive = "0x4411111b",
    }
end

hl.config({
    general = {
        gaps_in       = 4,
        gaps_out      = 8,
        border_size   = 2,
        layout        = "dwindle",
        allow_tearing = false,
        col = {
            active_border   = { colors = { current_theme.active_1, current_theme.active_2, current_theme.active_3 or current_theme.active_1 }, angle = 45 },
            inactive_border = current_theme.inactive or "0xff313244",
        },
    },

    decoration = {
        rounding         = 12,
        active_opacity   = 0.98,
        inactive_opacity = 0.88,

        -- Dimming sutil para focar a janela ativa
        dim_inactive     = true,
        dim_strength     = 0.12,
        dim_special      = 0.25,

        blur = {
            enabled           = true,
            size              = 6,
            passes            = 3,
            new_optimizations = true,
            ignore_opacity    = true,
            special           = true,
        },

        -- Glow atmosférico estendido na janela ativa
        shadow = {
            enabled        = true,
            range          = 22,
            render_power   = 4,
            color          = current_theme.shadow or "0x88cba6f7",
            color_inactive = current_theme.shadow_inactive or "0x4411111b",
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    misc = {
        disable_splash_rendering        = true,
        disable_hyprland_guiutils_check = true,
        force_default_wallpaper        = 0,
        disable_hyprland_logo           = true,
        enable_swallow                  = true,
        swallow_regex                   = "^(kitty|alacritty)$",
        focus_on_activate               = false,
    },

    debug = {
        vfr = true,
    },
})

-- Modern Elastic / Deceleration Bezier Curves (Material 3 & Smooth Feel)
hl.curve("md3_decel", {
    type   = "bezier",
    points = { { 0.05, 0.9 }, { 0.1, 1.05 } },
})

hl.curve("md3_accel", {
    type   = "bezier",
    points = { { 0.3, 0 }, { 0.8, 0.15 } },
})

-- Animations Configuration (Popin elegante e slidefade fluido)
hl.animation({ leaf = "windows",          enabled = true, speed = 5, bezier = "md3_decel", style = "popin 82%" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 4, bezier = "md3_accel", style = "popin 85%" })
hl.animation({ leaf = "windowsMove",      enabled = true, speed = 5, bezier = "md3_decel", style = "slide" })
hl.animation({ leaf = "fade",             enabled = true, speed = 5, bezier = "md3_decel" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 6, bezier = "md3_decel", style = "slidefade 25%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "md3_decel", style = "slidefadevert 25%" })
