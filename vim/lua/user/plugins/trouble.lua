return {
    "folke/trouble.nvim",
    dependencies = {
        "folke/which-key.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("trouble").setup({
            icons = false,
            fold_open = "v",              -- icon used for open folds
            fold_closed = ">",            -- icon used for closed folds
            indent_lines = false,         -- add an indent guide below the fold icons
            use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
            signs = {                     -- icons / text used for a diagnostic
                error = "error",
                warning = "warn",
                hint = "hint",
                information = "info",
            },
        })

        kr.set_trouble_mapping()
    end
}
