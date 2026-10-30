-- =============================================================================
-- NEOVIM KEYMAPS
-- =============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- 1. Fix cedilla if system/keyboard layout outputs 'ć'
map('i', 'ć', 'ç', { noremap = true, desc = 'Cedilha minúsculo' })
map('i', 'Ć', 'Ç', { noremap = true, desc = 'Cedilha maiúsculo' })

-- 2. Fast Save & Quit
map('n', '<leader>w', '<cmd>w<CR>', { desc = 'Salvar arquivo' })
map('n', '<leader>q', '<cmd>q<CR>', { desc = 'Fechar janela' })
map('n', '<leader>Q', '<cmd>qa!<CR>', { desc = 'Forçar saída de tudo' })

-- 3. Clear search highlights with ESC
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Limpar destaque da busca' })

-- 4. Window navigation shortcuts
map('n', '<C-h>', '<C-w>h', { desc = 'Mover para janela esquerda' })
map('n', '<C-j>', '<C-w>j', { desc = 'Mover para janela inferior' })
map('n', '<C-k>', '<C-w>k', { desc = 'Mover para janela superior' })
map('n', '<C-l>', '<C-w>l', { desc = 'Mover para janela direita' })

-- 5. Window resizing
map('n', '<C-Up>', '<cmd>resize +2<CR>', { desc = 'Aumentar altura' })
map('n', '<C-Down>', '<cmd>resize -2<CR>', { desc = 'Diminuir altura' })
map('n', '<C-Left>', '<cmd>vertical resize -2<CR>', { desc = 'Diminuir largura' })
map('n', '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = 'Aumentar largura' })

-- 6. Better indenting in visual mode (keeps selection)
map('v', '<', '<gv', { desc = 'Desidentar mantendo seleção' })
map('v', '>', '>gv', { desc = 'Identar mantendo seleção' })

-- 7. Move selected lines up/down
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Mover bloco para baixo' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Mover bloco para cima' })
