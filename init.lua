local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- Nvim options
vim.g.mapleader = " "
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true

require("lazy").setup({
	-- Themes
	{
		"AlexvZyl/nordic.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nordic").setup({
				transparent_bg = true,
				telescope = {
					style = "classic",
				},
				cursorline = {
					theme = "light",
					blend = 0.35,
				},
			})
			require("nordic").load()
		end,
	},

	-- {
	-- 	"ellisonleao/gruvbox.nvim",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("gruvbox").setup({
	-- 			terminal_colors = true,
	-- 			contrast = "hard",
	-- 			transparent_mode = true,
	-- 			-- inverse = true,
	-- 		})
	-- 		vim.cmd("colorscheme gruvbox")
	-- 	end,
	-- },
	-- {
	-- 	"projekt0n/github-nvim-theme",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("github-theme").setup({
	-- 			options = { darken = { floats = true }, transparent = true },
	-- 		})
	-- 		vim.cmd([[colorscheme github_dark_default]])
	-- 	end,
	-- },
	-- side folder tree
	{
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({})
		end,
		keys = {
			{ "<leader>e", ":NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
			{
				"<leader>E",
				":NvimTreeFocus<CR>",
				desc = "Focus NvimTree",
			},
		},
	},
	-- git decorations
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	-- Lazy Git interface
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
	-- Cursor line
	{
		"yamatsum/nvim-cursorline",
		config = function()
			require("nvim-cursorline").setup({
				cursorline = {
					enable = true,
					timeout = 1000,
					number = false,
				},
				cursorword = {
					enable = true,
					min_length = 3,
					hl = { underline = true },
				},
			})
		end,
	},
	--Status Line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = false,
				},
			})
		end,
	},
	-- Nvim surround - change characters
	--
	-- surr*ound_words             ysiw)           (surround_words)
	-- *make strings               ys$"            "make strings"
	-- [delete ar*ound me!]        ds]             delete around me!
	-- remove <b>HTML t*ags</b>    dst             remove HTML tags
	-- 'change quot*es'            cs'"            "change quotes"
	-- <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
	-- delete(functi*on calls)     dsf             function calls
	--
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	-- Utility line
	-- {
	-- 	"utilyre/barbecue.nvim",
	-- 	name = "barbecue",
	-- 	version = "*",
	-- 	dependencies = {
	-- 		"SmiteshP/nvim-navic",
	-- 	},
	-- 	opts = {},
	-- },
	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					layout_strategy = "vertical",
					layout_config = {
						preview_cutoff = 1,
						prompt_position = "bottom",
						mirror = true,
						vertical = {
							mirror = false,
						},
					},
				},
			})

			local keymap = vim.keymap
			keymap.set("n", "<leader>ca", function()
				require("telescope.builtin").lsp_code_actions()
			end, { desc = "Code Actions" })
		end,
	},
	-- Auto Comment
	{
		"terrortylor/nvim-comment",
		config = function()
			require("nvim_comment").setup({ create_mappings = false })
		end,
	},
	-- Autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	-- LSP Configuration & Plugins
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"folke/neodev.nvim",
		},
	},
	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",

			-- Adds LSP completion capabilities
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
	},
	-- Highlight, edit, and navigate code
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"yaml",
				"html",
				"css",
				"prisma",
				"markdown",
				"markdown_inline",
				"svelte",
				"graphql",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
				"c",
				"templ",
			},
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
		config = function(_, opts)
			-- Autoformat
			require("nvim-treesitter.install").prefer_git = true
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			animation = true,
		},
		version = "^1.0.0",
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			command_palette = { enable = true },
			views = {
				cmdline_popup = {
					position = {
						row = 15,
						col = "50%",
					},
					size = {
						width = "auto",
						height = "auto",
					},
				},
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					javascript = { "prettier", "prettierd" },
					typescript = { "prettier", "prettierd" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					svelte = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					graphql = { "prettier" },
					liquid = { "prettier" },
					lua = { "stylua" },
					python = { "isort", "black" },
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>f", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				})
			end, { desc = "Format file or range (in visual mode)" })
		end,
	},
	{
		"aznhe21/actions-preview.nvim",
		config = function()
			require("actions-preview").setup({
				telescope = {
					sorting_strategy = "ascending",
					layout_strategy = "vertical",
					layout_config = {
						width = 0.8,
						height = 0.9,
						prompt_position = "top",
						preview_cutoff = 20,
						preview_height = function(_, _, max_lines)
							return max_lines - 15
						end,
					},
				},
			})
		end,
	},
})

-- Keymaps --
local builtin = require("telescope.builtin")
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

vim.o.completeopt = "menuone,noselect"

keymap.set({ "n", "v" }, "<leader>p", '"_dP')
-- telescope
keymap.set("n", "<leader><leader>", builtin.find_files, {})
keymap.set("n", "<leader>g", builtin.live_grep, {})
-- code actions
keymap.set({ "v", "n" }, "<leader>ca", require("actions-preview").code_actions)
-- lsp format
keymap.set("n", "<leader>fm", vim.lsp.buf.format)
-- comment toggle
keymap.set({ "n", "v" }, "<leader>/", ":CommentToggle<cr>", opts)
-- Explore files
-- keymap.set("n", "<leader>E", ":Explore<cr>")
-- Copy to system clipboard (ctrl + c)
keymap.set({ "n", "v" }, "<C-c>", '"+y<cr>')
-- Delete highlight after using "/" or "?"
keymap.set("n", "<leader>M", ":nohlsearch<cr>")
--buffer
--ESC + key is option + key, just changed in iterm settings: Profiles > keys > Esc+ enable
keymap.set("n", "<Esc>d", "<Cmd>BufferPrevious<CR>", opts)
keymap.set("n", "<Esc>f", "<Cmd>BufferNext<CR>", opts)
keymap.set("n", "<Esc>g", "<Cmd>BufferClose<CR>", opts)
-- Move lines up and down
keymap.set("n", "<C-j>", ":m .+1<CR>==")
keymap.set("n", "<C-k>", ":m .-2<CR>==")
keymap.set("i", "<C-j>", "<Esc>:m .+1<CR>==gi")
keymap.set("i", "<C-k>", "<Esc>:m .-2<CR>==gi")
keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")
keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- Indent multiple lines
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")
