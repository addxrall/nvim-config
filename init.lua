vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"vague2k/vague.nvim",
	"vinitkumar/oscura-vim",
	"bettervim/yugen.nvim",
	"tpope/vim-surround",
	"tpope/vim-abolish",
	"tpope/vim-endwise",
	"huyvohcmc/atlas.vim",
	"chriskempson/base16-vim",
	"Lokaltog/vim-distinguished",
	"protesilaos/tempus-themes-vim",
	"github/copilot.vim",
	"flazz/vim-colorschemes",
	{ "projekt0n/github-nvim-theme", name = "github-theme" },
	-- LSP Configuration & Plugins
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"mason-org/mason.nvim",
				version = "v1.11.0",
			},
			{
				"mason-org/mason-lspconfig.nvim",
				version = "v1.32.0",
			},
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
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}, -- this is equalent to setup({}) function
	},
	-- Set lualine as statusline
	{
		"nvim-lualine/lualine.nvim",
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = false,
				component_separators = "|",
				section_separators = "",
			},
		},
	},
	"ctjhoa/spacevim",
	{ "h-hg/fcitx.nvim" },
	{ "elixir-editors/vim-elixir", ft = "elixir" },
	{ "hashivim/vim-terraform", ft = "terraform" },
	"lukas-reineke/lsp-format.nvim",
	{ "fatih/vim-go", ft = { "go", "gohtmltmpl" } },
	{
		"sebdah/vim-delve",
		ft = "go",
		init = function()
			vim.g.delve_new_command = "tabnew"
		end,
	},
	{ "joerdav/templ.vim", ft = "templ" },
	"sbdchd/neoformat",
	"vim-test/vim-test",
	{
		"mattn/emmet-vim",
		init = function()
			vim.cmd([[
        imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
      ]])
		end,
	},
	{ "leafOfTree/vim-svelte-plugin", ft = "svelte" },
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
			{ "<leader>LG", "<cmd>LazyGit<cr>", desc = "LazyGit" },
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
	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- {
			--   "nvim-telescope/telescope-fzf-native.nvim",
			--   build = "make",
			--   cond = function()
			--     return vim.fn.executable("make") == 1
			--   end,
			-- },
		},
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
		end,
	},
	-- Auto Comment
	{
		"terrortylor/nvim-comment",
		config = function()
			require("nvim_comment").setup({ create_mappings = false })
		end,
	},
	-- Buffer
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					numbers = "none", -- "none", "ordinal", "both"
					offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
					show_close_icon = true,
					show_buffer_icons = true,
					separator_style = "blank", -- Options: "slant", "thick", "thin", "blank"
					enforce_regular_tabs = false,
					always_show_bufferline = true,
					sort_by = "id",
				},
			})
		end,
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
	{
		"sebdah/vim-delve",
		ft = "go",
		init = function()
			vim.g.delve_new_command = "tabnew"
		end,
	},
	--window resize, change
	{
		"mrjones2014/smart-splits.nvim",
		config = function()
			require("smart-splits").setup({
				ignored_buftypes = {
					"nofile",
					"quickfix",
					"prompt",
				},
				ignored_filetypes = { "NvimTree" },
				default_amount = 3,
				at_edge = "wrap",
				float_win_behavior = "previous",
				move_cursor_same_row = false,
				cursor_follows_swapped_bufs = false,
				ignored_events = {
					"BufEnter",
					"WinEnter",
				},
				multiplexer_integration = nil,
				disable_multiplexer_nav_when_zoomed = true,
				kitty_password = nil,
				log_level = "info",
			})
		end,
	},
})
