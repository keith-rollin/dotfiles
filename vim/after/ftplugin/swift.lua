--
-- Warn me about long lines in Swift files.
--
vim.opt_local.colorcolumn = "100"

-- Actually word wrap comments in Swift files. But don't do it for
-- other long lines containing actual code. I'll let the Swift formatter
-- handle that.
--
vim.opt_local.formatoptions:append("c") -- Auto wrap comments using textwidth
vim.opt_local.formatoptions:remove("t") -- Don't auto wrap other long lines
vim.opt_local.textwidth = 80
