-- Color scheme

vim.cmd.colorscheme("vim")
vim.cmd.highlight("ColorColumn", "ctermbg=DarkRed")
vim.cmd.highlight("NormalFloat", "ctermfg=0", "ctermbg=7") -- Body of floating windows
vim.cmd.highlight("FloatBorder", "ctermfg=0", "ctermbg=7") -- Border of floating windows

-- Match spec for git merge error markers.
-- TODO: Is there a lua-native equivalent?

vim.cmd("match ErrorMsg '^(<|=|>){7}([^=].+)?$'")

-- Customize the diagnostic display to show the source and error code along with
-- the error message.
--
-- TBD: Use vim.diagnostic.config.prefix or .suffix instead?

local function fmt(diagnostic)
    if diagnostic.code then
        return ("[%s] %s"):format(diagnostic.code, diagnostic.message)
    end
    return diagnostic.message
end

vim.diagnostic.config({
    virtual_text = {
        source = true,
        format = fmt,
    },
    float = {
        source = true,
        format = fmt,
    },
})
