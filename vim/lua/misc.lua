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
    -- "let l:oldpos = getpos('.') | let l:oldquery = getreg('/') | :%s/s+$//e | call setpos('.', l:oldpos) | call setreg('/', l:oldquery)"
    vim.cmd(":%s/s+$//e")
end

---- Bottleneck function for appending a new component to a path. This is not
---- done in a file-system-independent manner, but at least the hackishness is
---- localized to this one location.
----
--function! AppendPathComponent(path, filename)
--    if strpart(a:path, -1) != "/"
--        return a:path . "/" . a:filename
--    endif
--    return a:path . a:filename
--endfunction

---- Find a file in an ancestor directory, starting with cwd.
----
--function! FindInAncestorDirectory(filename)
--    let l:curpath = fnamemodify(getcwd(), ":p:h")
--    while 1
--        let l:filepath = AppendPathComponent(l:curpath, a:filename)
--        if glob(l:filepath) != ""
--            return l:filepath
--        endif
--        let l:newpath = fnamemodify(l:curpath, ":h")
--        if l:newpath == l:curpath
--            return ""
--        endif
--        let l:curpath = l:newpath
--    endwhile
--endfunction

---- Execute :make on a parent makefile.
----
--function! ParentMake()
--    let l:makefile = FindInAncestorDirectory("Makefile")
--    if l:makefile == ""
--        echoerr "### Can't find makefile for: " . getcwd()
--        return
--    endif
--    execute 'make -C ' . fnamemodify(l:makefile, ":h")
--endfunction

-- Reload the init.vim file, in case for some reason the autocmd above doesn't
-- do the trick. This mirrors my bash command that does the same thing with the
-- .zshrc file.

vim.api.nvim_create_user_command("Reload", ":source " .. vim.env.MYVIMRC, {})

-- Remind me what file I'm in.

vim.api.nvim_create_user_command("WhatAmI", ':echo expand("%")', {})
