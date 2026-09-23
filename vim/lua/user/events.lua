local custom_group = vim.api.nvim_create_augroup("custom_events", {})

-- Restore the last cursor position.
-- Based on idea from: 'help last-position-jump'.
-- Lua version based on: https://www.reddit.com/r/neovim/comments/tqeh9m/help_allow_lastpositionjump_or_opening_to_a
-- Additional tweaks from:  https://www.youtube.com/watch?v=v36vLiFVOXY
--
-- I added the call to win_findbuf() to help fix a problem with Blink. I would
-- sometimes get an error calling nvim_win_set_cursor(0, position) because the
-- buffer associated with the event was not in the current window. To address
-- this, just get all of the actual windows associated with the buffer and set
-- the cursor in each of them. We'll see if this works. Just in case, I wrapped
-- the call to nvim_win_set_cursor() in a pcall() so that if it fails, we don't
-- get an error message.

vim.api.nvim_create_autocmd("FileType", {
    desc = "Restore the last cursor position",
    group = custom_group,
    pattern = "*",
    callback = function(ev)
        -- Don't restore the cursor position if we're in diff mode.
        -- (It's not apparent to me if this is safe. I've seen indications that
        -- the current window may not be one showing the buffer issuing the
        -- FileType event.)
        if vim.wo.diff then
            return
        end

        -- Don't restore the cursor position for certain file types.
        local hands_off_these_files = { "gitcommit", "gitrebase", "netrw" }
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = ev.buf })
        if vim.tbl_contains(hands_off_these_files, filetype) then
            return
        end

        -- Don't restore the cursor position if the mark is out of range.
        local position = vim.api.nvim_buf_get_mark(ev.buf, '"')
        local mark_line = position[1]
        local line_count = vim.api.nvim_buf_line_count(ev.buf)
        if mark_line < 1 or mark_line > line_count then
            return
        end

        local windows = vim.fn.win_findbuf(ev.buf)
        vim.iter(windows):each(function(win)
            pcall(vim.api.nvim_win_set_cursor, win, position)
        end)
    end,
})

local set_filetype_configuration = function(pattern, callback)
    vim.api.nvim_create_autocmd("FileType", {
        group = custom_group,
        pattern = pattern,
        callback = callback,
    })
end
set_filetype_configuration({ "gitconfig", "lua", "markdown", "python", "swift", "text" },
    function()
        -- Extend the pattern that recognizes numbered lists to include bulleted
        -- lists. Also, extend 'formatoptions' to format numbered lists which,
        -- thanks to the change to 'formatlistpat', now includes bulleted lists.
        vim.opt_local.formatlistpat = [[^\s*\(\d\+[\]:.)}\t ]\s+\|[-*+]\)\s*]]
        vim.opt_local.formatoptions:append("n")
        vim.opt_local.colorcolumn = "+1"
    end)
set_filetype_configuration({ "lua", "markdown", "text" },
    function()
        vim.opt_local.textwidth = 80
    end)
set_filetype_configuration("gitconfig",
    function()
        vim.opt_local.expandtab = false
    end)
set_filetype_configuration("python",
    function()
        vim.opt_local.formatoptions:append("ro")
        vim.opt_local.textwidth = 88
    end)
set_filetype_configuration("swift",
    function()
        -- As established by swift-format.
        vim.opt_local.textwidth = "100"
    end)

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
    end,
})

-- Set up an event handler to establish LSP-related key bindings when we
-- enter a buffer that an LSP supports.
--
-- From ':help lsp-lint'
--
-- NB: See `help gra` as the start of documentation on what nvim enables by
-- default when an LSP attaches to a buffer. That information can guide what
-- else we want to enable here.

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    group = custom_group,
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

        -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
        if client:supports_method('textDocument/completion') then
            vim.opt.completeopt = { 'fuzzy', 'menu', 'noselect', 'popup' } -- Default = menu, popup
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })

            -- Add LSP-style completions to autocomplete/complete options.
            vim.opt.complete:append('o')
        end

        -- Enable inline-completion.
        if client:supports_method('textDocument/inlineCompletion') then
            vim.lsp.inline_completion.enable(true, { bufnr = ev.buf, client_id = client.id })
            vim.keymap.set('i', '<Tab>', function()
                    -- Try to insert the currently displayed completion
                    -- candidate into the buffer. If there is no candidate, then
                    -- pass along our trigger character.
                    if not vim.lsp.inline_completion.get({ bufnr = ev.buf }) then
                        return "<Tab>"
                    end
                end,
                { expr = true, desc = "Accept the current inline completion" })
        end

        -- Auto-format ("lint") on save.
        -- From example in `:help lsp-lint`.
        --
        -- TODO: Handle the case where the LSP has detached from this buffer. In
        -- that case, the client (used to fetch the client.id) will be invalid.
        -- See help for example in LspDetach.
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = custom_group,
                buffer = ev.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end
    end,
})

--
--
