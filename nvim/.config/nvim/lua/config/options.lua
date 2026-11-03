-- NEOVIM GENERAL OPTIONS

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & Indentation (4 spaces standard)
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance & UI
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false

-- Behavior
opt.clipboard = "unnamedplus" -- Wayland wl-clipboard sync
opt.mouse = "a"
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitbelow = true
opt.splitright = true
