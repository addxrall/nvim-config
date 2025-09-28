local status, telescope = pcall(require, "telescope")
if not status then
  vim.notify("Failed to load telescope", vim.log.levels.ERROR)
  return
end

local actions = require("telescope.actions")

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
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["<Enter>"] = actions.select_default,
        ["<esc>"] = actions.close,
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

pcall(telescope.load_extension, "fzf")
