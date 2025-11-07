-- This is the result of reducing from mason and related tools down to the
-- built-in LSP management facilities. Inspired by:
--
--      "How To Set Up LSP Natively in Neovim 0.11+"
--      https://www.youtube.com/watch?v=tdhxpn1XdjQ

vim.lsp.enable('lua_ls')
vim.lsp.enable('pyright')
vim.lsp.enable('ruff')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('sourcekit')
