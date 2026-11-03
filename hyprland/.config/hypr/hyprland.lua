-- HYPRLAND MAIN CONFIGURATION (LUA)
-- Fedora 44 & Hyprland 0.56+

---@module 'hl'

-- Força a recarga limpa de todos os módulos ao recarregar a configuração (hyprctl reload)
for k in pairs(package.loaded) do
    if k:match("^conf%.") or k == "mocha" or k == "current_theme" then
        package.loaded[k] = nil
    end
end

-- Theme & Palette (Catppuccin Mocha)
require("mocha")

-- Modular Subsystems
require("conf.env")
require("conf.input")
require("conf.appearance")
require("conf.rules")
require("conf.keybinds")
require("conf.startup")
