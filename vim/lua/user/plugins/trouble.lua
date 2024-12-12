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
        kr.mapping.set({
            { "<leader>x",  group = "Toggle" },
            { "<leader>xd", "<cmd>TroubleToggle lsp_document_diagnostics<CR>",  desc = "Toggle Document Diagnostics Window" },
            { "<leader>xf", "<cmd>TroubleToggle lsp_definitions<CR>",           desc = "Toggle LSP Definitions Window" },
            { "<leader>xl", "<cmd>TroubleToggle loclist<CR>",                   desc = "Toggle LocList Window" },
            { "<leader>xq", "<cmd>TroubleToggle quickfix<CR>",                  desc = "Toggle Quickfix Window" },
            { "<leader>xr", "<cmd>TroubleToggle lsp_references<CR>",            desc = "Toggle LSP References Window" },
            { "<leader>xt", "<cmd>TroubleToggle lsp_type_definitions<CR>",      desc = "Toggle LSP Type Definitions Window" },
            { "<leader>xw", "<cmd>TroubleToggle lsp_workspace_diagnostics<CR>", desc = "Toggle Workspace Diagnostics Window" },
            { "<leader>xx", "<cmd>TroubleToggle<CR>",                           desc = "Toggle Trouble Window" },
        })
    end,
}
