local M = {}

M.set_keymap_normal = function(lhs, rhs)
    vim.api.nvim_set_keymap("n", lhs, rhs, { noremap = true, silent = true })
end

M.set_keymap_visual = function(lhs, rhs)
    vim.api.nvim_set_keymap("v", lhs, rhs, { noremap = true, silent = true })
end

M.set_local = function(name, value)
    vim.api.nvim_set_option_value(name, value, { scope = "local" })
end

M.set_abbr = function(lhs, rhs)
    vim.cmd("abbr " .. lhs .. " " .. rhs)
end

local custom_group = vim.api.nvim_create_augroup("custom_events", {})
M.on_event = function(event, pattern, callback)
    vim.api.nvim_create_autocmd(event, {
        group = custom_group,
        pattern = pattern,
        callback = callback,
    })
end

M.on_create_or_open = function(pattern, callback)
    M.on_event({ "BufNewFile", "BufRead" }, pattern, callback)
end

M.on_read_post = function(pattern, callback)
    M.on_event("BufReadPost", pattern, callback)
end

M.on_write_pre = function(pattern, callback)
    M.on_event("BufWritePre", pattern, callback)
end

M.on_write_post = function(pattern, callback)
    M.on_event("BufWritePost", pattern, callback)
end

return M
