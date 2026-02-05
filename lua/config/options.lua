-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- UI
vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.cmdheight = 1

vim.opt.wrap = false

-- Mouse & Clipboard
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.smartindent = true
vim.opt.breakindent = true

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Undo / Backup / Swap
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Splits & Buffers
vim.opt.hidden = true
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.confirm = true
vim.opt.autoread = true

-- Completion & Timing (LSP / cmp)
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Whitespace & Invisible Characters
vim.opt.list = true
vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
}

-- Performance
vim.opt.lazyredraw = false
vim.opt.synmaxcol = 220
