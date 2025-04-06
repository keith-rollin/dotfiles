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
    end,
}
