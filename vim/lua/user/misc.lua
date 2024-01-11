-- Color scheme

vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = "LightGrey" })

-- Match spec for git merge error markers.
-- TODO: Is there a lua-native equivalent?

vim.cmd("match ErrorMsg '^(<|=|>){7}([^=].+)?$'")

-- Functions/Commands
-- ------------------

-- Reload the init.lua file.

vim.api.nvim_create_user_command("Reload", ":source " .. vim.env.MYVIMRC, {})

-- Remind me what file I'm in.

vim.api.nvim_create_user_command("WhatAmI", ':echo expand("%")', {})
