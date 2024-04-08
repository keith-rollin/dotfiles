return {
    "folke/trouble.nvim",
    dependencies = {
        "folke/which-key.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        icons = false,
        fold_open = "v",      -- icon used for open folds
        fold_closed = ">",    -- icon used for closed folds
        indent_lines = false, -- add an indent guide below the fold icons
        signs = {
            -- icons / text used for a diagnostic
            error = "error",
            warning = "warn",
            hint = "hint",
            information = "info",
        },
        use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
    },
    config = function()
        kr.mapping.set_normal({
            x = {
                name = "Trouble",
                x = {
                    function()
                        require("trouble").toggle()
                    end,
                    "Toggle Trouble Window",
                },
                w = {
                    function()
                        require("trouble").toggle("workspace_diagnostics")
                    end,
                    "Toggle Workspace Diagnostics Window",
                },
                d = {
                    function()
                        require("trouble").toggle("document_diagnostics")
                    end,
                    "Toggle Document Diagnostics Window",
                },
                q = {
                    function()
                        require("trouble").toggle("quickfix")
                    end,
                    "Toggle Quickfix Window",
                },
                l = {
                    function()
                        require("trouble").toggle("loclist")
                    end,
                    "Toggle LocList Window",
                },
                f = {
                    function()
                        require("trouble").toggle("lsp_definitions")
                    end,
                    "Toggle LSP Definitions Window",
                },
                t = {
                    function()
                        require("trouble").toggle("lsp_type_definitions")
                    end,
                    "Toggle LSP Type Definitions Window",
                },
                r = {
                    function()
                        require("trouble").toggle("lsp_references")
                    end,
                    "Toggle LSP References Window",
                },
            },
        }, { prefix = "<leader>" })
    end,
}
