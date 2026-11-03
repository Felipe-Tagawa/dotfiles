--- Hyprland Environment Variables
--- Configured for Fedora 44 & Hyprland 0.56+
---@module 'hl'

-- Desktop Session
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Toolkit Wayland Backends
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- Applications Wayland Native Flags
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

-- Qt Wayland Configuration
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- Cursor Size & Themes
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE", "24")

-- Hardware & Multi-GPU (Aquamarine)
-- Primary AMD Cezanne iGPU, Secondary NVIDIA GTX 1650 dGPU
hl.env("AQ_DRM_DEVICES", "/dev/dri/amd-igpu:/dev/dri/nv-dgpu")
hl.env("AQ_MGPU_NO_EXPLICIT", "1")
