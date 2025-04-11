--
-- `Match` spec for git merge error markers.
--
vim.cmd.match("ErrorMsg '^(<|=|>){7}([^=].+)?$'")

--
-- Customize the diagnostic display to show the source and error code along with
-- the error message.
--
-- TBD: Use vim.diagnostic.config.prefix or .suffix instead?
--
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

--
-- Originally from some old vim.org tip that I can't find any more.
-- Modified with trim_trailing_whitespace handler in
-- runtime/editor/lua/editorconfig.lua
--
StripWhitespace = function()
    local oldquery = vim.fn.getreg("/")
    local view = vim.fn.winsaveview()
    vim.cmd("silent keepjumps keeppatterns %s/\\s\\+$//e")
    vim.fn.winrestview(view)
    vim.fn.setreg("/", oldquery)
end
