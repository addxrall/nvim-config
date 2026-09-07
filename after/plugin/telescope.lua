local status, telescope = pcall(require, "telescope")
if not status then
  vim.notify("Failed to load telescope", vim.log.levels.ERROR)
  return
end

local actions = require("telescope.actions")

-- ============================================================
--  UKLAD: zmien te jedna linijke i zrestartuj nvima.
--  Opcje: "vertical" | "horizontal" | "flex" | "dropdown" | "ivy"
-- ============================================================
local UKLAD = "vertical"

local uklady = {
  -- Twoj obecny. Prompt na gorze, lista pod nim, podglad na dole.
  vertical = {
    layout_strategy = "vertical",
    layout_config = {
      width = 0.8,
      height = 0.9,
      prompt_position = "top",
      preview_cutoff = 20,
      preview_height = 0.5,
    },
  },
  -- Klasyk: lista po lewej, podglad po prawej. Najlepszy przy szerokim monitorze.
  horizontal = {
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.9,
      height = 0.85,
      prompt_position = "top",
      preview_width = 0.55,
      preview_cutoff = 120,
    },
  },
  -- Sam sie przelacza: szeroko -> horizontal, waski split -> vertical.
  flex = {
    layout_strategy = "flex",
    layout_config = {
      width = 0.9,
      height = 0.85,
      prompt_position = "top",
      flip_columns = 140,
      horizontal = { preview_width = 0.55 },
      vertical = { preview_height = 0.5 },
    },
  },
  -- Maly popup na srodku, bez podgladu. Najszybszy wizualnie do skakania po plikach.
  dropdown = {
    layout_strategy = "center",
    layout_config = {
      width = 0.6,
      height = 0.4,
      prompt_position = "top",
    },
    borderchars = {
      prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
  },
  -- Panel przyklejony do dolu ekranu, jak w telescope-ui. Nie zaslania kodu.
  ivy = {
    layout_strategy = "bottom_pane",
    layout_config = {
      height = 0.4,
      prompt_position = "top",
      preview_width = 0.6,
    },
    border = true,
    borderchars = {
      prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
      results = { " " },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
  },
}

local wybrany = uklady[UKLAD] or uklady.vertical

telescope.setup({
  defaults = vim.tbl_extend("force", {
    -- Podglad WLACZONY. Wczesniej previewer=false zabijal go globalnie,
    -- przez co <leader>g (grep) pokazywal same sciezki bez kontekstu.
    sorting_strategy = "ascending",
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<D-j>"] = actions.move_selection_next,
        ["<D-k>"] = actions.move_selection_previous,
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
  }, wybrany),

  pickers = {
    -- Przy skakaniu po nazwach plikow podglad tylko spowalnia - wylaczony punktowo.
    find_files = { previewer = false },
    buffers = { previewer = false },
  },
})

pcall(telescope.load_extension, "fzf")
