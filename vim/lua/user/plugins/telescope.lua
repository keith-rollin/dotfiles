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
                file_ignore_patterns = { "__pycache__/" },
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

        kr.mapping.set({
            { "<leader>t",   group = "Telescope" },

            { "<leader>tf",  group = "Find Files" },
            { "<leader>tfc", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Fuzzy search in current buffer" },
            { "<leader>tff", "<cmd>Telescope find_files<CR>",                desc = "Search for files" },
            { "<leader>tfg", "<cmd>Telescope grep_string<CR>",               desc = "Search directory for hot string" },
            { "<leader>tfl", "<cmd>Telescope live_grep<CR>",                 desc = "Search open buffers" },
            { "<leader>tft", "<cmd>Telescope treesitter<CR>",                desc = "Show Treesitter query results" },

            { "<leader>tl",  group = "LSP" },
            { "<leader>tLS", "<cmd>Telescope lsp_workspace_symbols<CR>",     desc = "List document symbols in workspace" },
            { "<leader>tlI", "<cmd>Telescope lsp_incoming_calls<CR>",        desc = "List incoming calls for hot string" },
            { "<leader>tld", "<cmd>Telescope lsp_definitions<CR>",           desc = "Go to definition for hot string" },
            { "<leader>tli", "<cmd>Telescope lsp_implementation<CR>",        desc = "Go to implementation for hot string" },
            { "<leader>tlo", "<cmd>Telescope lsp_outgoing_calls<CR>",        desc = "List outgoing calls for hot string" },
            { "<leader>tlr", "<cmd>Telescope lsp_references<CR>",            desc = "List references for hot string" },
            { "<leader>tls", "<cmd>Telescope lsp_document_symbols<CR>",      desc = "List document symbols in current buffer" },
            { "<leader>tlt", "<cmd>Telescope lsp_type_definitions<CR>",      desc = "Go to type definition for hot string" },

            { "<leader>tt",  group = "Tags" },
            { "<leader>ttc", "<cmd>Telescope current_buffer_tags<CR>",       desc = "List tags in current buffer" },
            { "<leader>ttt", "<cmd>Telescope tags<CR>",                      desc = "List tags in current directory" },

            { "<leader>tg",  group = "git" },
            { "<leader>tgB", "<cmd>Telescope git_bcommits<CR>",              desc = "Show commits for current buffer" },
            { "<leader>tgS", "<cmd>Telescope git_stash<CR>",                 desc = "Show stash" },
            { "<leader>tgb", "<cmd>Telescope git_branches<CR>",              desc = "Show branches" },
            { "<leader>tgc", "<cmd>Telescope git_commits<CR>",               desc = "Show commits" },
            { "<leader>tgf", "<cmd>Telescope git_files<CR>",                 desc = "Show files tracked by git" },
            { "<leader>tgs", "<cmd>Telescope git_status<CR>",                desc = "Show status" },

            { "<leader>tp",  group = "Pickers" },
            { "<leader>tpb", "<cmd>Telescope builtin<CR>",                   desc = "Show builtin pickers" },
            { "<leader>tpr", "<cmd>Telescope resume<CR>",                    desc = "Resume the previous picker" },

            { "<leader>tk",  "<cmd>Telescope keymaps<CR>",                   desc = "Show normal mode keymaps" },
        })
    end,
}
