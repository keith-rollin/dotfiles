local custom_group = vim.api.nvim_create_augroup("custom_events", {})

-- Restore the last cursor position.
-- Based on idea from: 'help last-position-jump'.
-- Lua version based on: https://www.reddit.com/r/neovim/comments/tqeh9m/help_allow_lastpositionjump_or_opening_to_a

vim.api.nvim_create_autocmd("FileType", {
    group = custom_group,
    pattern = "*",
    callback = function()
        if (vim.o.filetype ~= "gitcommit") and (vim.o.filetype ~= "gitrebase") then
            local position = vim.api.nvim_buf_get_mark(0, '"')
            if position ~= { 0, 0 } then
                vim.api.nvim_win_set_cursor(0, position)
            end
        end
    end
})

-- Briefly highlight the yanked selection.
-- See ":help lua-highlight".
--
-- See also this video clip showing a Lua version:
--      https://youtu.be/m62UCkdQ8Ck?t=795

vim.api.nvim_create_autocmd("TextYankPost", {
    group = custom_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = 'Visual' })
    end -- Why can't I just set the callback to vim.highlight.on_yank?
})
