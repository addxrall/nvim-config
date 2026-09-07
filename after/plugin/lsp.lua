local status, mason = pcall(require, "mason")
local mlsp_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status or not mlsp_status then
  vim.notify("Failed to load mason or mason-lspconfig", vim.log.levels.ERROR)
  return
end

local servers = { "pyright", "ts_ls", "lua_ls" }

mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

-- automatic_enable=false jest KLUCZOWE: mason-lspconfig 2.x domyslnie wlacza KAZDY
-- serwer zainstalowany w masonie (masz ich 47), wiec bez tego na buforze .ts
-- ladowal sie ts_ls RAZEM z vtsls i efm - podwojna diagnostyka i podwojne podpowiedzi.
mason_lspconfig.setup({ ensure_installed = servers, automatic_enable = false })

vim.lsp.config("pyright", {
  settings = { python = { analysis = { autoSearchPaths = true } } },
})
vim.lsp.config("ts_ls", {
  settings = { typescript = { inlayHints = { includeInlayParameterNameHints = "all" } } },
})
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.enable(servers)

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf, noremap = true, silent = true }
    -- K, gri, ]d, [d, grn, gra sa domyslne od nvim 0.11 - nie duplikuje ich tutaj.
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", function()
      local ok, tiny = pcall(require, "tiny-code-action")
      if not ok then
        vim.notify("Failed to load tiny-code-action", vim.log.levels.ERROR)
        return
      end
      local done, err = pcall(tiny.code_action)
      if not done then
        vim.notify("Error in tiny-code-action: " .. tostring(err), vim.log.levels.ERROR)
      end
    end, vim.tbl_extend("force", opts, { desc = "Code Actions" }))
    -- Formatowanie przy zapisie robi WYLACZNIE Neoformat (after/plugin/neoformat.vim).
    -- Wczesniej byl tu jeszcze BufWritePre z vim.lsp.buf.format - obydwa bily sie o ten sam zapis.
  end,
})
