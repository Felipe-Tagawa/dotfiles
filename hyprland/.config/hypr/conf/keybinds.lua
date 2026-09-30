-- --- Atalhos Principais ($mod = Super/Windows) ---

local mod = "SUPER"

-- Essenciais
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + M", hl.dsp.exit())
hl.bind(mod .. " + E", hl.dsp.exec_cmd("thunar"))
hl.bind(mod .. " + Space", hl.dsp.window.float())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + D", hl.dsp.exec_cmd("~/.config/rofi/launchers/type-3/launcher.sh"))
hl.bind(mod .. " + X", hl.dsp.exec_cmd("wlogout -p layer-shell"))
hl.bind(mod .. " + K", hl.dsp.exec_cmd("bash -c 'hyprctl switchxkblayout all next'"))
hl.bind(mod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))

-- Alternar entre monitor Estendido e Espelhado
hl.bind(mod .. " + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-projetor.sh"))

-- Aplicativos Rápidos
hl.bind(mod .. " + F1", hl.dsp.exec_cmd("firefox"))
hl.bind(mod .. " + F4", hl.dsp.exec_cmd("discord"))
hl.bind(mod .. " + F7", hl.dsp.exec_cmd("steam"))
hl.bind(mod .. " + I", hl.dsp.exec_cmd("kitty nvim"))

-- Captura de Tela
hl.bind(mod .. " + Print", hl.dsp.exec_cmd('grim - | wl-copy && notify-send "Screenshot" "Tela cheia copiada"'))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot" "Área copiada"'))

-- Clipboard
hl.bind(mod .. " + V", hl.dsp.exec_cmd("~/.config/hypr/scripts/clipboard_history.sh"))
hl.bind(mod .. " + SHIFT + V", hl.dsp.exec_cmd('wl-paste | cliphist store && notify-send "Clipboard" "Salvo no histórico"'))
hl.bind(mod .. " + CTRL + V", hl.dsp.exec_cmd('wl-paste --type image | cliphist store && notify-send "Clipboard" "Imagem salva"'))
hl.bind(mod .. " + CTRL + SHIFT + V", hl.dsp.exec_cmd("~/.config/hypr/scripts/clipboard_clear.sh"))

-- Multimídia e Brilho
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume_notification.sh mute"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume_notification.sh down"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume_notification.sh up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness_notification.sh down"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness_notification.sh up"))

-- WiFi
hl.bind(mod .. " + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wifi_menu.sh"))
hl.bind(mod .. " + CTRL + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wifi_toggle.sh"))
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("nm-connection-editor"))
hl.bind(mod .. " + ALT + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wifi_status.sh"))
hl.bind(mod .. " + CTRL + SHIFT + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wifi_disconnect.sh"))

-- Navegação de Foco (Vim Style + Setas)
hl.bind(mod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + j", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Movimentação de Janelas (Super + Shift + Setas / HJKL)
hl.bind(mod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Mouse
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Workspaces (1-10)
for i = 1, 9 do
    hl.bind(mod .. " + " .. tostring(i), hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. tostring(i), hl.dsp.window.move({ workspace = i }))
end
hl.bind(mod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Workspace Especial (Scratchpad)
hl.bind(mod .. " + grave", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = "special:scratchpad" }))

-- Utilidades
hl.bind(mod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mod .. " + C", hl.dsp.exec_cmd("hyprpicker | wl-copy"))
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("killall waybar && hyprctl reload && ~/.config/waybar/start.sh"))
hl.bind(mod .. " + CTRL + G", hl.dsp.exec_cmd('envycontrol -s nvidia && notify-send "GPU" "Mudando para NVIDIA (Requer Reboot)"'))
