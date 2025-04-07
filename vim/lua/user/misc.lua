-- Color scheme

vim.cmd.colorscheme("vim")

-- I want to add "italic" to the current theme's color scheme. I can't just use
-- the nvim_set_hl() function because it doesn't merge the new attributes--it
-- completely replaces the existing ones. So I need to get the current highlight
-- definition, update it, and then set it back.
--
-- https://www.reddit.com/r/neovim/comments/wcmqi7/a_simple_utility_function_to_override_and_update/
-- https://gist.github.com/lkhphuc/ea6db0458268cad1493b2674cb0fda51
--
-- Note that the function provided in the gist doesn't work as-is because it
-- uses the deprecated nvim_get_hl_by_name(). I've updated it to use the newer
-- nvim_get_hl().

local merge = true
local replace = false

local function update_highlight(hl_name, opts, merge_or_replace)
    if not merge_or_replace then
        vim.api.nvim_set_hl(0, hl_name, {})
    end
    local is_ok, hl_def = pcall(vim.api.nvim_get_hl, 0, { name = hl_name, create = true })
    if is_ok then
        for k, v in pairs(opts) do hl_def[k] = v end
        -- Complains about not being able to assign hl_def (type
        -- vim.api.keyset.get_hl_info) to vim.api.keyset.highlight
        ---@diagnostic disable: param-type-mismatch
        vim.api.nvim_set_hl(0, hl_name, hl_def)
    end
end

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
    group = vim.api.nvim_create_augroup('Color', {}),
    pattern = "*",
    callback = function()
        update_highlight("Comment", { italic = true }, merge)
        update_highlight("Pmenu", { fg = "Black", bg = "LightGrey" }, merge)
        update_highlight("FloatBorder", { fg = "Black", bg = "LightGrey" }, replace)

        -- CursorLine is not showing up. I'm not sure why. The following is how
        -- it's configured in my color scheme:
        --
        --      :highlight CursorLine
        --      CursorLine     xxx cterm=underline guibg=Grey90
        --
        -- Visual highlighting does work, though, and it has an appearance that
        -- I like, so let's just copy that.
        --
        --      :highlight Visual
        --      Visual         xxx ctermfg=0 ctermbg=248 guifg=Black guibg=LightGrey
        --
        -- Aaaand...now that I look at it, I see that Visual isn't really the
        -- way I'd like it. It forces the foreground to be black. Instead, I'd
        -- like to retain the normal highlighted foreground colors. So let's set
        -- that up while we're at it.

        update_highlight("Visual", { bg = "LightGrey" }, replace)
        update_highlight("CursorLine", { link = "Visual" }, replace)
    end
})


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
