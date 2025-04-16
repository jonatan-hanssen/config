local g = vim.g
local opt = vim.opt

g.mapleader = " "
g.maplocalleader = " "

-- indents

opt.smartindent = true

opt.smartindent = true
opt.expandtab = true
opt.breakindent = true
opt.shiftwidth = 4
opt.tabstop = 4

-- visuals
opt.relativenumber = true
opt.number = true
opt.scrolloff = 999
opt.cursorline = true
opt.list = true
opt.listchars= "lead:·,trail:·,tab:>·"

-- mouse
opt.mouse = "a"
