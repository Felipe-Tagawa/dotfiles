--- Hyprland Autostart and Session Daemon Initialization
--- Configured according to Fedora 44 (KF6) & Hyprland 0.56+
---@module 'hl'

hl.on("hyprland.start", function()
    -- Sync environment variables with DBus and systemd user services
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Desktop interface and theming preferences
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-mauve-standard+default'")

    -- Polkit Authentication Agent (Fedora 44 uses KF6 polkit-kde agent)
    hl.exec_cmd("bash -c '[ -x /usr/libexec/kf6/polkit-kde-authentication-agent-1 ] && /usr/libexec/kf6/polkit-kde-authentication-agent-1 || /usr/libexec/polkit-kde-authentication-agent-1'")

    -- Notification Daemon, OSD and Bar
    hl.exec_cmd("bash -c 'if command -v swaync &>/dev/null; then systemctl --user start swaync.service; elif command -v dunst &>/dev/null; then dunst; fi'")
    hl.exec_cmd("bash -c 'command -v swayosd-server &>/dev/null && swayosd-server'")
    hl.exec_cmd("~/.config/waybar/start.sh")

    -- System Tray & Hardware Applets
    hl.exec_cmd("pkill nm-applet")
    hl.exec_cmd("blueman-applet")

    -- Wallpaper and Idle Management (Restores last chosen wallpaper on boot)
    hl.exec_cmd("bash -c 'command -v hypridle &>/dev/null && hypridle'")
    hl.exec_cmd("~/.config/hypr/scripts/theme-switcher.sh restore")

    -- Clipboard & Utilities (Cliphist daemon)
    hl.exec_cmd("~/.config/hypr/scripts/clipboard_daemon.sh")
    hl.exec_cmd("~/.config/hypr/scripts/battery_notification.sh")
    hl.exec_cmd("~/.config/hypr/scripts/border-animate.sh")
    hl.exec_cmd("~/.config/hypr/scripts/check_updates")
end)
