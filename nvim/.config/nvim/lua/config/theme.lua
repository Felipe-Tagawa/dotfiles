-- =============================================================================
-- NEOVIM THEME CONFIGURATION
-- Dynamic theme loader synchronized with desktop environment
-- =============================================================================

vim.o.background = "dark"

local theme_file = vim.fn.expand("~/.config/nvim/current_theme.txt")
local current_theme = "catppuccin-mocha"

if vim.fn.filereadable(theme_file) == 1 then
    local lines = vim.fn.readfile(theme_file)
    if #lines > 0 and lines[1] ~= "" then
        current_theme = vim.trim(lines[1])
    end
end

if current_theme == "gruvbox" then
    local has_gruvbox, gruvbox = pcall(require, "gruvbox")
    if has_gruvbox then
        gruvbox.setup({ contrast = "hard" })
        pcall(vim.cmd, "colorscheme gruvbox")
    else
        pcall(vim.cmd, "colorscheme desert")
    end
elseif current_theme == "rose-pine" then
    local ok, _ = pcall(vim.cmd, "colorscheme rose-pine")
    if not ok then pcall(vim.cmd, "colorscheme desert") end
elseif current_theme == "tokyonight" then
    local ok, _ = pcall(vim.cmd, "colorscheme tokyonight")
    if not ok then pcall(vim.cmd, "colorscheme desert") end
else
    local ok, _ = pcall(vim.cmd, "colorscheme catppuccin-mocha")
    if not ok then pcall(vim.cmd, "colorscheme desert") end
end
