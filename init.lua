vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

vim.o.completeopt = "menuone,noselect"
vim.opt.termguicolors = true

require("lazy").setup({
  -- Colorschemes
  {
    "slugbyte/lackluster.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme lackluster-mint")
    end,
  },
  { "projekt0n/github-nvim-theme", name = "github-theme" },
  "vinitkumar/oscura-vim",
  "bettervim/yugen.nvim",
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim",           version = "1.11.0" },
      { "mason-org/mason-lspconfig.nvim", version = "1.32.0" },
      { "j-hui/fidget.nvim",              opts = {} },
      {
        "folke/lazydev.nvim",
        opts = {
          library = { { path = "luvit-meta/library", words = { "vim" } } },
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup({
        sort = { sorter = "case_sensitive" },
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
      })
    end,
  },
  "tpope/vim-surround",
  "tpope/vim-abolish",
  "tpope/vim-endwise",
  "github/copilot.vim",
  { "windwp/nvim-autopairs",       event = "InsertEnter", opts = {} },
  {
    "nvim-lualine/lualine.nvim",
    opts = { options = { icons_enabled = false, component_separators = "|", section_separators = "" } },
  },
  { "elixir-editors/vim-elixir", ft = "elixir" },
  { "hashivim/vim-terraform",    ft = "terraform" },
  { "fatih/vim-go",              ft = { "go", "gohtmltmpl" } },
  { "joerdav/templ.vim",         ft = "templ" },
  "sbdchd/neoformat",
  "vim-test/vim-test",
  {
    "mattn/emmet-vim",
    init = function()
      vim.cmd('imap <expr> <tab> emmet#expandAbbrIntelligent("\\<tab>")')
    end,
  },
  {
    "sphamba/smear-cursor.nvim",
    config = function()
      require("smear_cursor").setup({
        smear_between_buffers = true,
        smear_between_neighbor_lines = true,
        scroll_buffer_space = true,
        legacy_computing_symbols_support = false,
        smear_insert_mode = true,
      })
      require("smear_cursor").enabled = true
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { { "<leader>LG", "<cmd>LazyGit<cr>", desc = "LazyGit" } },
  },
  {
    "yamatsum/nvim-cursorline",
    config = function()
      require("nvim-cursorline").setup({
        cursorline = { enable = true, timeout = 1000, number = false },
        cursorword = { enable = true, min_length = 3, hl = { underline = true } },
      })
    end,
  },
  {
    "terrortylor/nvim-comment",
    config = function()
      require("nvim_comment").setup({ create_mappings = false })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    config = function()
      require("bufferline").setup({
        options = {
          numbers = "none",
          offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
          show_close_icon = true,
          show_buffer_icons = true,
          separator_style = "blank",
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
        cmdline_popup = { position = { row = 15, col = "50%" }, size = { width = "auto", height = "auto" } },
      },
    },
    dependencies = { "MunifTanjim/nui.nvim" },
  },
  {
    "sebdah/vim-delve",
    ft = "go",
    init = function()
      vim.g.delve_new_command = "tabnew"
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      require("smart-splits").setup({
        ignored_buftypes = { "nofile", "quickfix", "prompt" },
        ignored_filetypes = { "NvimTree" },
        default_amount = 3,
        at_edge = "wrap",
        float_win_behavior = "previous",
        move_cursor_same_row = false,
        cursor_follows_swapped_bufs = false,
        ignored_events = { "BufEnter", "WinEnter" },
        multiplexer_integration = nil,
        disable_multiplexer_nav_when_zoomed = true,
        log_level = "info",
      })
    end,
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    event = "LspAttach",
    opts = {
      picker = "telescope",
      backend = "vim",
    },
  },
})
