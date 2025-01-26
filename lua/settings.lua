-- Global editor settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Option settings
vim.opt.autochdir = true
vim.opt.breakindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.cmdheight = 1
vim.opt.colorcolumn = '80'
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.cursorcolumn = true
vim.opt.cursorline = true
vim.opt.errorbells = false
vim.opt.expandtab = true
vim.opt.exrc = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.inccommand = 'split'
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.path:append '**'
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 4
vim.opt.shortmess:append 'c'
vim.opt.showmode = false
vim.opt.signcolumn = 'no'
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.spelllang = 'en_gb'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.timeoutlen = 500
vim.opt.title = true
vim.opt.undofile = true
vim.opt.updatetime = 50
vim.opt.wildmode = { 'longest', 'full' }
vim.opt.wrap = false

-- vim: ts=2 sts=2 sw=2 et
