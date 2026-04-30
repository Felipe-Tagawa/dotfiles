-- 1. Corrige o cedilha (se o seu sistema estiver mandando 'ć')
vim.keymap.set('i', 'ć', 'ç', { noremap = true })
vim.keymap.set('i', 'Ć', 'Ç', { noremap = true })

-- 2. Atalho para salvar rápido (ajuda muito no fluxo de dev)
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Salvar arquivo' })

-- 3. Números relativos nas linhas (ótimo para se mover no código)
vim.opt.number = true
vim.opt.relativenumber = true

-- 4. Tabulação (padrão de 4 espaços para Python/Java)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

require("gruvbox").setup({
    terminal_colors = true, -- define as cores do terminal
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true, -- invert background for search, quiet accents
    contrast = "hard", -- AQUI: "soft", "medium" ou "hard"
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
})

-- No init.lua
vim.o.background = "dark"
vim.g.gruvbox_contrast_dark = 'hard' -- Isso garante o fundo igual ao terminal

-- Tente carregar o tema
local status, _ = pcall(vim.cmd, "colorscheme gruvbox")
if not status then
    print("Aviso: Gruvbox não encontrado. Rodando com tema padrão.")
end
