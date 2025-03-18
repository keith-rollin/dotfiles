local custom_group = vim.api.nvim_create_augroup("custom_events", {})

-- Restore the last cursor position.
-- Based on idea from: 'help last-position-jump'.
-- Lua version based on: https://www.reddit.com/r/neovim/comments/tqeh9m/help_allow_lastpositionjump_or_opening_to_a

vim.api.nvim_create_autocmd("FileType", {
    desc = "Restore the last cursor position",
    group = custom_group,
    pattern = "*",
    callback = function()
        local hands_off_these_files = { "gitcommit", "gitrebase", "netrw" }
        if not vim.tbl_contains(hands_off_these_files, vim.o.filetype) then
            -- Get the last position as {row, col}, where row is 1-based. Get
            -- {0,0} if there is no mark.
            local position = vim.api.nvim_buf_get_mark(0, '"')
            if position == { 0, 0 } then
                return
            end
            local max_line = vim.fn.line("$")
            if position[1] > max_line then
                position[1] = max_line
            end
            vim.api.nvim_win_set_cursor(0, position)
        end
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Disable Copilot for Advent of Code Swift files",
    group = custom_group,
    pattern = "*",
    callback = function()
        local path = vim.api.nvim_buf_get_name(0)
        if string.find(path, "/advent%-of%-code/") ~= nil then
            vim.cmd("Copilot disable")
        elseif string.find(path, "/aoc/") ~= nil then
            vim.cmd("Copilot disable")
        else
            vim.cmd("Copilot enable")
        end
    end,
})

-- Briefly highlight the yanked selection.
-- See ":help lua-highlight".
--
-- See also this video clip showing a Lua version:
--      https://youtu.be/m62UCkdQ8Ck?t=795

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight the yanked text",
    group = custom_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual" })
    end, -- Why can't I just set the callback to vim.highlight.on_yank?
})
