local utils = require("utils")

-- Tell vim-autoformat where python is.

vim.g.python3_host_prog = vim.fn.exepath("python3.11")

-- Configure stylua to indent with spaces, not tabs. This is the default
-- configuration line for formatdef_stylua but with "--indent-type Spaces"
-- added.

vim.g.formatdef_stylua =
    "'stylua --indent-type Spaces --search-parent-directories --stdin-filepath ' . expand('%:p') . ' -- -'"

-- For debugging.
-- vim.g.autoformat_verbosemode = 2

-- Call Autoformat when writing Python, Rust, or Lua files.

utils.on_write_pre({ "*.py", "*.rs", "*.lua" }, function()
    vim.cmd("Autoformat")
end)
