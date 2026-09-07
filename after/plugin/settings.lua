vim.o.shell = "/bin/bash"

-- Wciecia
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.lbr = true

-- Numeracja / UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.laststatus = 2
vim.opt.showcmd = true
vim.wo.signcolumn = "yes"
vim.opt.guicursor = ""
vim.opt.foldenable = false

-- Szukanie
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true -- bylo false, a <leader>M mapowal :nohlsearch w prozne

-- Pliki
vim.opt.hidden = true
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.eol = true
vim.o.undofile = true

vim.o.mouse = "a"
vim.o.updatetime = 250

vim.g.neoformat_only_msg_on_error = true
