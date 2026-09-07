-- after/plugin/keymappings.lua

local status, builtin = pcall(require, "telescope.builtin")
if not status then
  vim.notify("Failed to load telescope.builtin", vim.log.levels.ERROR)
  return
end

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Wklejanie bez nadpisywania rejestru
keymap({ "n", "v" }, "<leader>p", '"_dP', opts)
keymap({ "n", "v" }, "<C-c>", '"+y', opts)
keymap("n", "<leader>M", ":nohlsearch<CR>", opts)

-- Szukanie (telescope)
keymap("n", "<leader><leader>", builtin.find_files, opts)
keymap("n", "<leader>g", builtin.live_grep, opts)

-- To samo w fzf-lua, zeby porownac. Jak wygra - podmieniam na <leader><leader>/<leader>g.
keymap("n", "<leader>ff", ":FzfLua files<CR>", { desc = "fzf-lua: pliki", silent = true })
keymap("n", "<leader>fg", ":FzfLua live_grep<CR>", { desc = "fzf-lua: grep", silent = true })

-- Komentarze: wbudowane gc/gcc (nvim 0.10+), bez wtyczki. remap=true bo gcc samo jest mapowaniem.
keymap("n", "<leader>/", "gcc", { remap = true, silent = true, desc = "Komentarz" })
keymap("v", "<leader>/", "gc", { remap = true, silent = true, desc = "Komentarz" })

-- Bufory. Bylo <ESC>d/<ESC>f - kazdy Esc w normal mode czekal timeoutlen.
keymap("n", "<S-h>", ":BufferLineCyclePrev<CR>", opts)
keymap("n", "<S-l>", ":BufferLineCycleNext<CR>", opts)
keymap("n", "<leader>bd", ":BufferLinePickClose<CR>", opts)
keymap("n", "<leader>bo", ":BufferLineCloseOthers<CR>", opts)
for i = 1, 9 do
  keymap("n", "<leader>" .. i, ":BufferLineGoToBuffer " .. i .. "<CR>", opts)
end

-- Okna (wbudowane <C-w>, bez smart-splits)
keymap("n", "<leader>sv", ":vsplit<CR>", opts)
keymap("n", "<leader>sh", ":split<CR>", opts)
keymap("n", "<leader>sc", ":close<CR>", opts)
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<leader>h", "<C-w>h", opts)
keymap("n", "<leader>j", "<C-w>j", opts)
keymap("n", "<leader>k", "<C-w>k", opts)
keymap("n", "<leader>l", "<C-w>l", opts)
keymap("n", "<A-h>", "<C-w><", opts)
keymap("n", "<A-j>", "<C-w>-", opts)
keymap("n", "<A-k>", "<C-w>+", opts)
keymap("n", "<A-l>", "<C-w>>", opts)

-- Przesuwanie linii
keymap("n", "<C-j>", ":m .+1<CR>==", opts)
keymap("n", "<C-k>", ":m .-2<CR>==", opts)
keymap("i", "<C-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("i", "<C-k>", "<Esc>:m .-2<CR>==gi", opts)
keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Drzewo plikow
local tree = require("nvim-tree.api").tree
keymap("n", "<leader>e", tree.toggle, { desc = "Toggle NvimTree", noremap = true, silent = true })
keymap("n", "<leader>E", tree.focus, { desc = "Focus NvimTree", noremap = true, silent = true })

-- Nie zostawiaj samego drzewa jako ostatniego okna
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.bo.filetype == "NvimTree" and #vim.api.nvim_list_wins() == 1 and vim.fn.argc() == 0 then
      vim.cmd("quit")
    end
  end,
})
