vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
  -- Colorscheme
  {
    "slugbyte/lackluster.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("lackluster").setup({
        tweak_syntax = {
          comment = "#999999",
        },
        tweak_highlight = {
          ["@tag"] = { fg = "#bbbbbb" },
          ["@tag.delimiter"] = { fg = "#bbbbbb" },
          ["@tag.builtin"] = { fg = "#bbbbbb" },
          ["htmlTagName"] = { fg = "#bbbbbb" },
          ["NvimTreeFolder"] = { fg = "#bbbbbb" },
          ["NvimTreeFolderIcon"] = { fg = "#bbbbbb" },
          ["NvimTreeRootFolder"] = { fg = "#bbbbbb" },
        },
      })
      vim.cmd("colorscheme lackluster-mint")
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = { { path = "luvit-meta/library", words = { "vim" } } },
        },
      },
    },
  },

  -- Uzupelnianie
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
  },
  "github/copilot.vim",

  -- Wyszukiwanie
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },
  -- Do porownania z telescope: <leader>ff / <leader>fg (patrz keymappings.lua)
  -- WYMAGA binarki fzf w PATH: brew install fzf. Sama wtyczka to tylko wrapper.
  { "ibhagwan/fzf-lua", cmd = "FzfLua" },

  -- Drzewo plikow
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

  -- Git
  { "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" }, opts = {} },
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { { "<leader>LG", "<cmd>LazyGit<cr>", desc = "LazyGit" } },
  },

  -- Edycja
  "tpope/vim-surround",
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "sbdchd/neoformat", cmd = "Neoformat" },

  -- UI
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = { options = { icons_enabled = false, component_separators = "|", section_separators = "" } },
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
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
    },
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
    "rachartier/tiny-code-action.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    event = "LspAttach",
    opts = {
      picker = "telescope",
      backend = "vim",
    },
  },

  -- Jezyki
  { "fatih/vim-go", ft = { "go", "gohtmltmpl" } },
})
