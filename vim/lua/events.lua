local utils = require("utils")

-- Set text width to 80 for text and Lua files.

utils.on_create_or_open({ "*.txt", "*.lua" }, function()
    utils.set_local("textwidth", 80)
end)

-- Set a right-most colorcolumn for Python files.

utils.on_create_or_open({ "*.py" }, function()
    utils.set_local("textwidth", 88)
    utils.set_local("colorcolumn", "+1")
end)

-- Treat .json files as .js.

utils.on_create_or_open({ "*.json" }, function()
    utils.set_local("filetype", "json")
    utils.set_local("syntax", "javascript")
end)

-- Treat .md files as Markdown.

utils.on_create_or_open({ "*.markdown", "*.mdown", "*.mkd", "*.mkdn", "*.mdwn", "*.md", "*.MD" }, function()
    utils.set_local("textwidth", 80)
    utils.set_local("filetype", "markdown")
end)

-- Treat .mm files as Objective-C.

utils.on_create_or_open({ "*.mm" }, function()
    utils.set_local("filetype", "objc")
end)

-- Restore the last cursor position.
-- Based on idea from: 'help last-position-jump'.
-- Lua version based on: https://www.reddit.com/r/neovim/comments/tqeh9m/help_allow_lastpositionjump_or_opening_to_a

utils.on_read_post("*", function()
    if vim.o.filetype ~= "commit" and vim.o.filetype ~= "rebase" then
        local position = vim.api.nvim_buf_get_mark(0, '"')
        if position ~= { 0, 0 } then
            vim.api.nvim_win_set_cursor(0, position)
        end
    end
end)

-- Briefly highlight the yanked selection.
-- See ":help lua-highlight".
--
-- See also this video clip showing a Lua version:
--      https://youtu.be/m62UCkdQ8Ck?t=795

utils.on_event(
    "TextYankPost",
    "*",
    function()
        vim.highlight.on_yank()
    end -- Why can't I just pass in vim.highlight.on_yank?
)

-- Reload our configuration file when it changes.
-- TODO: How do also reload when modules change? Maybe walk package.loaded.
-- TODO: This breaks autoformatting after reloading. This is because we create
--       a new custom_group -- clearing it out -- but we don't re-execute the
--       require'd modules and re-fill the custom group.

-- on_write_post({ "init.lua" }, function()
--     dofile(vim.env.MYVIMRC)
-- end)
