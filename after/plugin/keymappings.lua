local function get_git_root()
	local dot_git_path = vim.fn.finddir(".git", ".;")
	return vim.fn.fnamemodify(dot_git_path, ":p:h:h")
end

local function dlv_debug_git_root()
	local git_root = get_git_root()
	vim.fn["delve#runCommand"]("debug", "", git_root)
end

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		vim.keymap.set("n", "<F8>", ":DlvToggleBreakpoint<CR>", { buffer = true, silent = true, noremap = true })
		local bufname = vim.api.nvim_buf_get_name(0)
		if bufname:match("_test.go") then
			vim.keymap.set("n", "<F12>", ":DlvTest<CR>", { noremap = true, buffer = true })
		else
			vim.keymap.set("n", "<F12>", dlv_debug_git_root, { noremap = true, buffer = true })
		end
	end,
	pattern = { "go" },
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
keymap.set("n", "<ESC>d", ":BufferLineCyclePrev<CR>", opts)
keymap.set("n", "<ESC>f", ":BufferLineCycleNext<CR>", opts)
keymap.set("n", "<ESC>g", ":BufferLinePickClose<CR>", opts)
keymap.set("n", "<ESC>G", ":BufferLineCloseOthers<CR>", opts)

for i = 1, 9 do
	keymap.set("n", "<leader>" .. i, ":BufferLineGoToBuffer " .. i .. "<CR>", opts)
end

--windows
keymap.set("n", "<leader>sv", ":vsplit<CR>", opts)
keymap.set("n", "<leader>sh", ":split<CR>", opts)
keymap.set("n", "<leader>sc", ":close<CR>", opts)
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)

keymap.set("n", "<A-h>", require("smart-splits").resize_left)
keymap.set("n", "<A-j>", require("smart-splits").resize_down)
keymap.set("n", "<A-k>", require("smart-splits").resize_up)
keymap.set("n", "<A-l>", require("smart-splits").resize_right)

keymap.set("n", "<leader>h", require("smart-splits").move_cursor_left)
keymap.set("n", "<leader>j", require("smart-splits").move_cursor_down)
keymap.set("n", "<leader>k", require("smart-splits").move_cursor_up)
keymap.set("n", "<leader>l", require("smart-splits").move_cursor_right)

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
