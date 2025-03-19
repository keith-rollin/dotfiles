-- Set the ColorColumn color.
-- Help from: https://www.reddit.com/r/neovim/comments/x3zp6t/comment/imsi3xt/
-- See `:help cterm-colors` for valid colors.

local ns = vim.api.nvim_create_namespace('swift')
vim.api.nvim_set_hl(ns, 'ColorColumn', { ctermbg = 7 })
vim.api.nvim_win_set_hl_ns(0, ns)

vim.opt_local.colorcolumn = "100"

-- Adjust the formatting for bulleted lists starting with "*".

vim.bo.comments = vim.bo.comments .. ",fb:*"
