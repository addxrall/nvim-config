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
