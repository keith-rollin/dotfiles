return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "folke/which-key.nvim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        -- For file lists (those returned by find_files and git_files, show the
        -- file name first, followed by the path displayed in the "Comment"
        -- style, per:
        --
        -- https://github.com/nvim-telescope/telescope.nvim/issues/2014#issuecomment-1873547633

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "TelescopeResults",
            callback = function(ctx)
                vim.api.nvim_buf_call(ctx.buf, function()
                    vim.fn.matchadd("TelescopeParent", "\t\t.*$")
                    vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
                end)
            end,
        })

        local function filenameFirst(_, path)
            local tail = vim.fs.basename(path)
            local parent = vim.fs.dirname(path)
            if parent == "." then
                return tail
            end
            return string.format("%s\t\t%s", tail, parent)
        end

        require("telescope").setup({
            defaults = {
                path_display = { "tail" },
            },
            pickers = {
                live_grep = { theme = "dropdown" },
                grep_string = { theme = "dropdown" },
                find_files = { theme = "dropdown", previewer = false, path_display = filenameFirst },
                git_files = { theme = "dropdown", previewer = false, path_display = filenameFirst },
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
