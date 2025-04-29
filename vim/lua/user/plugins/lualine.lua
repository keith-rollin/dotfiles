--
-- I don't feel compelled to use a custom statusline. However, I've installed
-- lualine for two reasons:
--
-- * The terminal and vim theme I'm using (cattpuccin) seems to result in a
--   status line that doesn't have a background color. This makes it hard to
--   read. lualine makes it easy to install a theme that makes the status
--   line readable.
--
-- * lualine has a datetime component that shows the continually-updated time.
--
return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        options = {
            theme = "gruvbox_dark", -- Change from "auto"
            component_separators = '',
            section_separators = { left = '', right = '' },
            always_show_tabline = false,
            globalstatus = true,
        },
        sections = {
            lualine_x = { { "datetime", style = "%F %T" } }, -- Replace encoding, fileformat, and filetype
            lualine_z = { {
                function()
                    local col = vim.fn.charcol('.')
                    local line = vim.fn.line('.')
                    local lines = vim.fn.line('$')
                    return string.format('%d | %d | %d', col, line, lines)
                end
            } },
        },
    },
}
