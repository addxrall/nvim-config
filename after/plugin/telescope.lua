-- after/plugin/telescope.lua

local status, telescope = pcall(require, "telescope")
if not status then
  vim.notify("Failed to load telescope", vim.log.levels.ERROR)
  return
end

local actions = require("telescope.actions")

-- Configure Telescope
telescope.setup({
  defaults = {
    previewer = false,
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
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["j"] = actions.move_selection_next,     -- Navigate down
        ["k"] = actions.move_selection_previous, -- Navigate up
        ["<Enter>"] = actions.select_default,    -- Accept selection
        ["<esc>"] = actions.close,               -- Close picker
      },
      n = {
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["<Enter>"] = actions.select_default,
        ["q"] = actions.close,
        ["<esc>"] = actions.close,
      },
    },
  },
})

-- Load fzf extension if available
pcall(telescope.load_extension, "fzf")

-- Find files with ripgrep
local function find_with_rg()
  require("telescope.builtin").find_files({
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

-- Live grep in git root
local function find_git_root()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  if current_file == "" then
    current_dir = cwd
  else
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require("telescope.builtin").live_grep({
      search_dirs = { git_root },
    })
  end
end

-- Keymaps
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<C-p>", find_with_rg, opts)
keymap("n", "<leader>/", ":LiveGrepGitRoot<CR>", { desc = "Search by Grep on Git Root", noremap = true, silent = true })
vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})
