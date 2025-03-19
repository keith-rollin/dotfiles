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

local function update_highlight(hl_name, opts)
    local is_ok, hl_def = pcall(vim.api.nvim_get_hl, 0, { name = hl_name, create = true })
    if is_ok then
        for k, v in pairs(opts) do hl_def[k] = v end
        vim.api.nvim_set_hl(0, hl_name, hl_def)
    end
end

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
    group = vim.api.nvim_create_augroup('Color', {}),
    pattern = "*",
    callback = function()
        update_highlight("Comment", { italic = true })

        -- Clear out the old FloatBorder first, or it seems that it will still
        -- link to WinSeparator -> VertSplit -> Normal -> <cleared>, which seems
        -- to give us a grey background rather than a black one.
        vim.api.nvim_set_hl(0, "FloatBorder", {})

        update_highlight("Pmenu", { fg = "Grey", bg = "Black" })
        update_highlight("FloatBorder", { fg = "Grey", bg = "Black" })
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
