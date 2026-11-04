--- Hyprland Keybindings & Mouse Binds
--- Configured according to Hyprland 0.56+ Lua API
---@module 'hl'

local mod = "SUPER"

-- ESSENTIAL SYSTEM BINDS

hl.bind(mod .. " + Return", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + Q",      hl.dsp.window.close())
hl.bind(mod .. " + M",      hl.dsp.exit())
hl.bind(mod .. " + E",      hl.dsp.exec_cmd("dolphin"))
hl.bind(mod .. " + Space",  hl.dsp.window.float())
hl.bind(mod .. " + F",      hl.dsp.window.fullscreen())
hl.bind(mod .. " + D",      hl.dsp.exec_cmd("~/.config/rofi/launchers/type-3/launcher.sh"))
hl.bind(mod .. " + X",      hl.dsp.exec_cmd("wlogout -p layer-shell -b 5"))
hl.bind(mod .. " + K",      hl.dsp.exec_cmd("hyprctl switchxkblayout all next"))
hl.bind(mod .. " + L",      hl.dsp.exec_cmd("~/.config/hypr/scripts/lock.sh"))

-- Display projector toggle (Extended vs Mirrored)
hl.bind(mod .. " + P",      hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-projetor.sh"))

-- Dynamic Theme Switcher with Circular Growth Transition
hl.bind(mod .. " + S",         hl.dsp.exec_cmd("~/.config/hypr/scripts/theme-switcher.sh menu"))
hl.bind(mod .. " + ALT + S",   hl.dsp.exec_cmd("~/.config/hypr/scripts/theme-switcher.sh next"))
hl.bind(mod .. " + T",         hl.dsp.exec_cmd("~/.config/hypr/scripts/theme-switcher.sh wall"))

-- Screen Shaders & Color Profiles (Zen Mode, Vibrance, Night Light, CRT)
hl.bind(mod .. " + Y",         hl.dsp.exec_cmd("~/.config/hypr/scripts/shader-menu.sh"))
hl.bind(mod .. " + SHIFT + Y", hl.dsp.exec_cmd("~/.config/hypr/scripts/shader-menu.sh toggle"))

-- Rofi Beats (Lo-Fi, Synthwave & Chillout Radio Player)
hl.bind(mod .. " + B",         hl.dsp.exec_cmd("~/.config/rofi/scripts/rofi-beats.sh"))

-- QUICK APPLICATION LAUNCHERS

hl.bind(mod .. " + F1", hl.dsp.exec_cmd("firefox"))
hl.bind(mod .. " + F4", hl.dsp.exec_cmd("discord"))
hl.bind(mod .. " + F7", hl.dsp.exec_cmd("steam"))
hl.bind(mod .. " + I",  hl.dsp.exec_cmd("kitty nvim"))
hl.bind(mod .. " + Z",  hl.dsp.exec_cmd("kitty --class cava-visualizer -e cava"))

-- SCREENSHOTS

hl.bind(mod .. " + Print", hl.dsp.exec_cmd('grim - | wl-copy && notify-send "Screenshot" "Tela cheia copiada para o clipboard"'))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot" "Área copiada para o clipboard"'))

-- CLIPBOARD MANAGEMENT

hl.bind(mod .. " + V",                hl.dsp.exec_cmd("~/.config/hypr/scripts/clipboard_history.sh"))
hl.bind(mod .. " + SHIFT + V",        hl.dsp.exec_cmd('wl-paste | cliphist store && notify-send "Clipboard" "Salvo no histórico"'))
hl.bind(mod .. " + CTRL + V",         hl.dsp.exec_cmd('wl-paste --type image | cliphist store && notify-send "Clipboard" "Imagem salva"'))
hl.bind(mod .. " + CTRL + SHIFT + V", hl.dsp.exec_cmd("~/.config/hypr/scripts/clipboard_history.sh clear"))

-- MULTIMEDIA & BRIGHTNESS

hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("~/.config/hypr/scripts/volume_notification.sh mute"), { locked = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("~/.config/hypr/scripts/volume_notification.sh down"), { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("~/.config/hypr/scripts/volume_notification.sh up"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness_notification.sh down"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness_notification.sh up"),   { locked = true, repeating = true })

-- NETWORK & WI-FI SHORTCUTS

hl.bind(mod .. " + W",                hl.dsp.exec_cmd("~/.config/hypr/scripts/wifi.sh menu"))
hl.bind(mod .. " + CTRL + W",         hl.dsp.exec_cmd("~/.config/hypr/scripts/wifi.sh toggle"))
hl.bind(mod .. " + SHIFT + W",        hl.dsp.exec_cmd("nm-connection-editor"))
hl.bind(mod .. " + ALT + W",          hl.dsp.exec_cmd("~/.config/hypr/scripts/wifi.sh status"))
hl.bind(mod .. " + CTRL + SHIFT + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wifi.sh disconnect"))

-- FOCUS NAVIGATION (Vim style + Arrows)

hl.bind(mod .. " + h",     hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + l",     hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + k",     hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + j",     hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- WINDOW MOVEMENT (Super + Shift + Keys)

hl.bind(mod .. " + SHIFT + h",     hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + l",     hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + k",     hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + j",     hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

-- MOUSE WINDOW CONTROL

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- WORKSPACES (1 to 10)

for i = 1, 10 do
    local key = tostring(i % 10)
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- SPECIAL WORKSPACE (Scratchpad)

hl.bind(mod .. " + grave",         hl.dsp.exec_cmd("~/.config/hypr/scripts/dropdown-terminal.sh"))
hl.bind(mod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = "special:scratchpad" }))

-- SYSTEM UTILITIES & HYPRLAND CONTROLS

hl.bind(mod .. " + N",         hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mod .. " + C",         hl.dsp.exec_cmd("hyprpicker | wl-copy"))
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("killall waybar; hyprctl reload; ~/.config/waybar/start.sh"))
hl.bind(mod .. " + CTRL + G",  hl.dsp.exec_cmd('envycontrol -s nvidia && notify-send "GPU" "Mudando para NVIDIA (Requer Reboot)"'))
