return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
        -- See `:help catppuccin-configuration` for all configuration options.
        require("catppuccin").setup({
            transparent_background = true,
        })
        vim.cmd.colorscheme("catppuccin")
    end
}
