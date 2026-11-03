-- NEOVIM THEME CONFIGURATION
-- Dynamic theme loader synchronized with desktop environment

vim.o.background = "dark"

local theme_file = vim.fn.expand("~/.config/nvim/current_theme.txt")
local current_theme = "catppuccin-mocha"

if vim.fn.filereadable(theme_file) == 1 then
    local lines = vim.fn.readfile(theme_file)
    if #lines > 0 and lines[1] ~= "" then
        current_theme = vim.trim(lines[1])
    end
end

-- Transparência harmônica com o terminal Kitty
local function apply_transparency()
    local groups = {
        "Normal",
        "NormalNC",
        "NormalFloat",
        "FloatBorder",
        "SignColumn",
        "LineNr",
        "CursorLineNr",
        "EndOfBuffer",
    }
    for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
    end
end

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = apply_transparency,
})

if current_theme == "gruvbox" then
    local has_gruvbox, gruvbox = pcall(require, "gruvbox")
    if has_gruvbox then
        gruvbox.setup({ contrast = "hard", transparent_mode = true })
        pcall(vim.cmd, "colorscheme gruvbox")
    else
        pcall(vim.cmd, "colorscheme desert")
    end
elseif current_theme == "rose-pine" then
    local has_rp, rp = pcall(require, "rose-pine")
    if has_rp then
        rp.setup({ styles = { transparency = true } })
    end
    local ok, _ = pcall(vim.cmd, "colorscheme rose-pine")
    if not ok then pcall(vim.cmd, "colorscheme desert") end
elseif current_theme == "tokyonight" then
    local has_tn, tn = pcall(require, "tokyonight")
    if has_tn then
        tn.setup({ transparent = true })
    end
    local ok, _ = pcall(vim.cmd, "colorscheme tokyonight")
    if not ok then pcall(vim.cmd, "colorscheme desert") end
else
    local has_cat, cat = pcall(require, "catppuccin")
    if has_cat then
        cat.setup({ transparent_background = true })
    end
    local ok, _ = pcall(vim.cmd, "colorscheme catppuccin-mocha")
    if not ok then pcall(vim.cmd, "colorscheme desert") end
end

apply_transparency()
