local status, mason = pcall(require, "mason")
local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status or not mason_lspconfig_status then
  vim.notify("Failed to load mason or mason-lspconfig", vim.log.levels.ERROR)
  return
end

mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

mason_lspconfig.setup({
  ensure_installed = { "pyright", "ts_ls", "lua_ls" },
  automatic_installation = true,
})

-- Configure LSP servers using new API
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

local servers = { "pyright", "ts_ls", "lua_ls" }
for _, server in ipairs(servers) do
  local ok, err = pcall(vim.lsp.enable, { server })
  if not ok then
    vim.notify("Failed to enable LSP server " .. server .. ": " .. tostring(err), vim.log.levels.ERROR)
  end
end

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
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, opts)
    -- Code actions with tiny-code-action.nvim
    vim.keymap.set({ "n", "v" }, "<leader>ca", function()
      local ok, tiny_code_action = pcall(require, "tiny-code-action")
      if not ok then
        vim.notify("Failed to load tiny-code-action", vim.log.levels.ERROR)
        return
      end
      local ok, err = pcall(tiny_code_action.code_action)
      if not ok then
        vim.notify("Error in tiny-code-action: " .. tostring(err), vim.log.levels.ERROR)
      end
    end, { buffer = ev.buf, desc = "Code Actions", noremap = true, silent = true })
    if vim.lsp.buf.format then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  end,
})
