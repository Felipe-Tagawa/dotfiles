-- NEOVIM AUTOCMDS

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local general_group = augroup("GeneralSettings", { clear = true })

-- 1. Highlight on yank (visual feedback when copying)
autocmd("TextYankPost", {
    group = general_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    end,
    desc = "Destacar texto copiado",
})

-- 2. Return to last edit position when opening a file
autocmd("BufReadPost", {
    group = general_group,
    pattern = "*",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
    desc = "Restaurar cursor na última posição editada",
})

-- 3. Close specific window types easily with 'q'
autocmd("FileType", {
    group = general_group,
    pattern = { "qf", "help", "man", "notify", "lspinfo", "checkhealth" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
    end,
    desc = "Fechar janelas utilitárias com 'q'",
})
