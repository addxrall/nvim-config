vim.api.nvim_create_autocmd("FileType", {
  pattern = { "make", "go", "php", "rust", "cs" },
  command = "setlocal tabstop=4 shiftwidth=4 noexpandtab fileformat=unix",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  command = "setlocal tabstop=2 shiftwidth=2 noexpandtab",
})

vim.cmd([[source ~/.config/nvim/after/plugin/neoformat.vim]])
