-- after/plugin/keymappings.lua

local function get_git_root()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(dot_git_path, ":p:h:h")
end

local function dlv_debug_git_root()
  local git_root = get_git_root()
  vim.fn["delve#runCommand"]("debug", "", git_root)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go" },
  callback = function()
    vim.keymap.set("n", "<F8>", ":DlvToggleBreakpoint<CR>", { buffer = true, silent = true, noremap = true })
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname:match("_test.go") then
      vim.keymap.set("n", "<F12>", ":DlvTest<CR>", { noremap = true, buffer = true })
    else
      vim.keymap.set("n", "<F12>", dlv_debug_git_root, { noremap = true, buffer = true })
    end
  end,
})

-- Keymaps
local status, builtin = pcall(require, "telescope.builtin")
if not status then
  vim.notify("Failed to load telescope.builtin", vim.log.levels.ERROR)
  return
end

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap({ "n", "v" }, "<leader>p", '"_dP', opts)
keymap("n", "<leader><leader>", builtin.find_files, opts)
keymap("n", "<leader>g", builtin.live_grep, opts)
keymap({ "n", "v" }, "<leader>/", ":CommentToggle<CR>", opts)
keymap({ "n", "v" }, "<C-c>", '"+y', opts)
keymap("n", "<leader>M", ":nohlsearch<CR>", opts)
keymap("n", "<ESC>d", ":BufferLineCyclePrev<CR>", opts)
keymap("n", "<ESC>f", ":BufferLineCycleNext<CR>", opts)
keymap("n", "<ESC>g", ":BufferLinePickClose<CR>", opts)
keymap("n", "<ESC>G", ":BufferLineCloseOthers<CR>", opts)
for i = 1, 9 do
  keymap("n", "<leader>" .. i, ":BufferLineGoToBuffer " .. i .. "<CR>", opts)
end
keymap("n", "<leader>sv", ":vsplit<CR>", opts)
keymap("n", "<leader>sh", ":split<CR>", opts)
keymap("n", "<leader>sc", ":close<CR>", opts)
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<A-h>", require("smart-splits").resize_left, opts)
keymap("n", "<A-j>", require("smart-splits").resize_down, opts)
keymap("n", "<A-k>", require("smart-splits").resize_up, opts)
keymap("n", "<A-l>", require("smart-splits").resize_right, opts)
keymap("n", "<leader>h", require("smart-splits").move_cursor_left, opts)
keymap("n", "<leader>j", require("smart-splits").move_cursor_down, opts)
keymap("n", "<leader>k", require("smart-splits").move_cursor_up, opts)
keymap("n", "<leader>l", require("smart-splits").move_cursor_right, opts)
keymap("n", "<C-j>", ":m .+1<CR>==", opts)
keymap("n", "<C-k>", ":m .-2<CR>==", opts)
keymap("i", "<C-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("i", "<C-k>", "<Esc>:m .-2<CR>==gi", opts)
keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap(
  "n",
  "<leader>e",
  require("nvim-tree.api").tree.toggle,
  { desc = "Toggle NvimTree", noremap = true, silent = true }
)
keymap("n", "<leader>E", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_buf_get_option(buf, "filetype")
    if ft == "NvimTree" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
  vim.notify("NvimTree is not open", vim.log.levels.WARN)
end, { desc = "Focus NvimTree if open", noremap = true, silent = true })

-- Modified BufEnter autocommand to prevent quitting on startup
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.bo.filetype == "NvimTree" and #vim.api.nvim_list_wins() == 1 and vim.fn.argc() == 0 then
      vim.cmd("quit")
    end
  end,
})
