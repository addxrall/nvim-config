-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local actions = require("telescope.actions")

require("telescope").setup({
	defaults = {
		previewer = false,
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<esc>"] = actions.close,
			},
		},
	},
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
	-- Use the current buffer's path as the starting point for the git search
	local current_file = vim.api.nvim_buf_get_name(0)
	local current_dir
	local cwd = vim.fn.getcwd()
	-- If the buffer is not associated with a file, return nil
	if current_file == "" then
		current_dir = cwd
	else
		-- Extract the directory from the current file's path
		current_dir = vim.fn.fnamemodify(current_file, ":h")
	end

	-- Find the Git root directory from the current file's path
	local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
	if vim.v.shell_error ~= 0 then
		print("Not a git repository. Searching on current working directory")
		return cwd
	end
	return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
	local git_root = find_git_root()
	if git_root then
		require("telescope.builtin").live_grep({
			search_dirs = { git_root },
		})
	end
end

local telescope = require("telescope.builtin")
local function find_with_rg()
	telescope.find_files({
		find_command = {
			"rg",
			"--files",
			"--hidden",
			"--ignore",
			"-g",
			"!.git",
			"-g",
			"!.jj",
		},
	})
end

vim.keymap.set("n", "<C-p>", find_with_rg, { noremap = true })

vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

vim.keymap.set("n", "<leader>ca", function()
	require("telescope.builtin").lsp_code_actions()
end, { desc = "Code Actions" })

-- -- See `:help telescope.builtin`
-- vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
-- vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
-- vim.keymap.set("n", "<leader>/", function()
-- 	-- You can pass additional configuration to telescope to change theme, layout, etc.
-- 	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
-- 		winblend = 10,
-- 		previewer = false,
-- 	}))
-- end, { desc = "[/] Fuzzily search in current buffer" })
--
-- vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "Search [G]it [F]iles" })
-- vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
-- vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
-- vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
-- vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
-- vim.keymap.set("n", "<leader>/", ":LiveGrepGitRoot<cr>", { desc = "[S]earch by [G]rep on Git Root" })
-- vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
-- vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })
-- vim.keymap.set("n", "<leader>Ts", require("telescope.builtin").colorscheme)
