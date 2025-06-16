vim.o.shell = "/bin/bash"
vim.opt.nu = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.hidden = true
vim.opt.laststatus = 2
vim.opt.showcmd = true
vim.opt.swapfile = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.o.smartcase = true
vim.opt.lbr = true
vim.opt.smartindent = true
vim.opt.eol = true
vim.opt.autoread = true
vim.opt.foldenable = false
vim.opt.guicursor = ""
-- vim.o.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
vim.opt.relativenumber = true

-- wait time for commands to go
-- vim.opt.updatetime = 300
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
vim.wo.signcolumn = "yes"

vim.opt.termguicolors = true

vim.g.mapleader = " "

vim.g.neoformat_only_msg_on_error = true

vim.g.vim_svelte_plugin_use_typescript = 1
vim.g.vim_svelte_plugin_use_sass = 1

-- Set highlight on search
vim.o.hlsearch = false

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- wait time for commands to go
-- Decrease update time
-- vim.o.updatetime = 250
-- vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = false,
	underline = true,
	severity_sort = true,
})

vim.o.updatetime = 250

vim.api.nvim_create_autocmd("CursorHold", {
	pattern = "*",
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false, border = "rounded" })
	end,
})

-- vim.cmd.colorscheme(os.getenv("VIM_COLORSCHEME") or "default")
-- vim.cmd.colorscheme("yugen")
-- vim.cmd.colorscheme("vague")
-- vim.cmd.colorscheme("oscura")
-- vim.cmd.colorscheme("default")
-- vim.cmd.colorscheme("github_dark_default")
-- vim.cmd.colorscheme("kanso")
-- vim.cmd.colorscheme("monochrome")
-- if os.getenv("NO_SYNTAX") == "true" then
-- 	vim.cmd.syntax("off")
-- end
