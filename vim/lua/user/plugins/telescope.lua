return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "folke/which-key.nvim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("telescope").setup({
            defaults = {
                path_display = { "tail" },
            },
            pickers = {
                live_grep = { theme = "dropdown" },
                grep_string = { theme = "dropdown" },
                find_files = { theme = "dropdown", previewer = false },
                buffers = { theme = "dropdown", previewer = false, initial_mode = "normal" },
                colorscheme = { enable_preview = true },
                lsp_references = { theme = "dropdown", initial_mode = "normal" },
                lsp_definitions = { theme = "dropdown", initial_mode = "normal" },
                lsp_declarations = { theme = "dropdown", initial_mode = "normal" },
                lsp_implementations = { theme = "dropdown", initial_mode = "normal" },
            },

        })

        kr.mapping.set_normal_leader({
            t = {
                name = "Telescope",
                f = {
                    name = "Find files",
                    l = { "<cmd>Telescope live_grep<CR>", "Search open buffers" },
                    g = { "<cmd>Telescope grep_string<CR>", "Search directory for hot string" },
                    f = { "<cmd>Telescope find_files<CR>", "Search for files" },
                    t = { "<cmd>Telescope treesitter<CR>", "Show Treesitter query results" },
                    c = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "Fuzzy search in current buffer" },
                },

                l = {
                    name = "LSP",
                    r = { "<cmd>Telescope lsp_references<CR>", "List references for hot string" },
                    I = { "<cmd>Telescope lsp_incoming_calls<CR>", "List incoming calls for hot string" },
                    O = { "<cmd>Telescope lsp_outgoing_calls<CR>", "List outgoing calls for hot string" },
                    d = { "<cmd>Telescope lsp_definitions<CR>", "Go to definition for hot string" },
                    t = { "<cmd>Telescope lsp_type_definitions<CR>", "Go to type definition for hot string" },
                    i = { "<cmd>Telescope lsp_implementation<CR>", "Go to implementation for hot string" },
                    s = { "<cmd>Telescope lsp_document_symbols<CR>", "List document symbols in current buffer" },
                    S = { "<cmd>Telescope lsp_workspace_symbols<CR>", "List document symbols in workspace" },
                },

                t = {
                    name = "Tags",
                    t = { "<cmd>Telescope tags<CR>", "List tags in current directory" },
                    c = { "<cmd>Telescope current_buffer_tags<CR>", "List tags in current buffer" },
                },

                g = {
                    name = "git",
                    f = { "<cmd>Telescope git_files<CR>", "Show files tracked by git" },
                    c = { "<cmd>Telescope git_commits<CR>", "Show commits" },
                    B = { "<cmd>Telescope git_bcommits<CR>", "Show commits for current buffer" },
                    b = { "<cmd>Telescope git_branches<CR>", "Show branches" },
                    s = { "<cmd>Telescope git_status<CR>", "Show status" },
                    S = { "<cmd>Telescope git_stash<CR>", "Show stash" },
                },

                p = {
                    name = "Pickers",
                    b = { "<cmd>Telescope builtin<CR>", "Show builtin pickers" },
                    r = { "<cmd>Telescope resume<CR>", "Resume the previous picker" },
                },

                k = { "<cmd>Telescope keymaps<CR>", "Show normal mode keymaps" },
            }
        })
    end,
}
