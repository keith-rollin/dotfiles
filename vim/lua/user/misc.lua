-- Color scheme

vim.cmd.highlight("ColorColumn", "ctermbg=DarkRed")
vim.cmd.highlight("NormalFloat", "ctermfg=0", "ctermbg=7") -- Body of floating windows
vim.cmd.highlight("FloatBorder", "ctermfg=0", "ctermbg=7") -- Border of floating windows

-- Match spec for git merge error markers.
-- TODO: Is there a lua-native equivalent?

vim.cmd("match ErrorMsg '^(<|=|>){7}([^=].+)?$'")
