local custom_group = vim.api.nvim_create_augroup("custom_events", {})

-- Restore the last cursor position.
-- Based on idea from: 'help last-position-jump'.
-- Lua version based on: https://www.reddit.com/r/neovim/comments/tqeh9m/help_allow_lastpositionjump_or_opening_to_a

-- I sometimes get this when Blink shows the completion menu. Line 24 is/was the
-- one calling vim.api.nvim_win_set_cursor:
--
-- Error detected while processing FileType Autocommands for "*":
-- Error executing lua callback: /Users/keith/.config/nvim/lua/user/events.lua:24: Cursor position outside buffer
-- stack traceback:
--         [C]: in function 'nvim_win_set_cursor'
--         /Users/keith/.config/nvim/lua/user/events.lua:24: in function </Users/keith/.config/nvim/lua/user/events.lua:11>
--         [C]: in function 'nvim_set_option_value'
--         ...re/nvim/lazy/blink.cmp/lua/blink/cmp/lib/window/init.lua:132: in function 'open'
--         ...lazy/blink.cmp/lua/blink/cmp/completion/windows/menu.lua:95: in function 'open'
--         ...lazy/blink.cmp/lua/blink/cmp/completion/windows/menu.lua:61: in function 'open_with_items'
--         ...re/nvim/lazy/blink.cmp/lua/blink/cmp/completion/init.lua:70: in function 'callback'
--         .../nvim/lazy/blink.cmp/lua/blink/cmp/lib/event_emitter.lua:28: in function 'emit'
--         ...re/nvim/lazy/blink.cmp/lua/blink/cmp/completion/list.lua:96: in function 'show'
--         ...re/nvim/lazy/blink.cmp/lua/blink/cmp/completion/init.lua:53: in function <...re/nvim/lazy/blink.cmp/lua/blink/cmp/completion/init.lua:29>

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
            position[2] = 0 -- Wild attempt to fix the above noted error.
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
        if vim.g.loaded_copilot == nil then
            return
        end
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

-- Set up an event handler to establish LSP-related key bindings when we
-- enter a buffer that an LSP supports.

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function() -- (ev)
        kr.set_diagnostic_mapping()
        kr.set_lsp_mapping()

        -- Should I use this or do I use blink?
        --
        -- local client = vim.lsp.get_client_by_id(ev.data.client_id)
        -- if client and client:supports_method('textDocument/completion') then
        --     vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'fuzzy', 'popup' }
        --     vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        --     vim.keymap.set('i', '<C-Space', function()
        --         vim.lsp.completion.get()
        --     end)
        -- end
    end,
})
