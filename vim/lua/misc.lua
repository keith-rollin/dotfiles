-- Color scheme

vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = "LightGrey" })

-- Match spec for git merge error markers.
-- TODO: Is there a lua-native equivalent?

vim.cmd("match ErrorMsg '^(<|=|>){7}([^=].+)?$'")

-- Set the default highlighting style for shell scripts. This particular
-- setting assumes that our scripts are POSIX compatible and so shows things
-- like $(...) without flagging it as invalid.

vim.g.is_posix = 1

-- netrw: Configuration

vim.g.netrw_banner = 0 -- Disable banner.
vim.g.netrw_liststyle = 3 -- Tree view.

-- Functions/Commands
-- ------------------

-- Strip trailing whitespace.

StripWhitespace = function()
    -- TODO: Translate to native Lua.
    -- NOTE: Had to disable this full version. Things like "l:oldpos" are now flagged as errors in nvim 0.9.4.
    -- "let l:oldpos = getpos('.') | let l:oldquery = getreg('/') | :%s/s+$//e | call setpos('.', l:oldpos) | call setreg('/', l:oldquery)"
    vim.cmd(":%s/s+$//e")
end

-- Reload the init.lua file.

vim.api.nvim_create_user_command("Reload", ":source " .. vim.env.MYVIMRC, {})

-- Remind me what file I'm in.

vim.api.nvim_create_user_command("WhatAmI", ':echo expand("%")', {})
