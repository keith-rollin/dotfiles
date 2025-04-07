return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "folke/which-key.nvim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("telescope").setup({
            defaults = {
                path_display = { "tail" },
                file_ignore_patterns = { "__pycache__/" },
            },
            pickers = {
                live_grep = { theme = "dropdown" },
                grep_string = { theme = "dropdown" },
                find_files = { theme = "dropdown", previewer = false, path_display = { "filename_first" } },
                git_files = { theme = "dropdown", previewer = false, path_display = { "filename_first" } },
                buffers = { theme = "dropdown", previewer = false, initial_mode = "normal" },
                colorscheme = { enable_preview = true },
                lsp_references = { theme = "dropdown", initial_mode = "normal" },
                lsp_definitions = { theme = "dropdown", initial_mode = "normal" },
                lsp_declarations = { theme = "dropdown", initial_mode = "normal" },
                lsp_implementations = { theme = "dropdown", initial_mode = "normal" },
            },
        })

        kr.set_telescope_mapping()
    end,
}
