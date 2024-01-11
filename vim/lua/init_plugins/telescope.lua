return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("telescope").setup()

        local opts = { noremap = true, silent = true }
        local set_keymap_normal = function(lhs, rhs)
            vim.keymap.set("n", lhs, rhs, opts)
        end

        -- Search for and in files

        set_keymap_normal("<leader>tlg", ":Telescope live_grep<CR>")                 -- Search open buffers
        set_keymap_normal("<leader>tgs", ":Telescope grep_string<CR>")               -- Search directory for hot string
        set_keymap_normal("<leader>tff", ":Telescope find_files<CR>")                -- Search for files
        set_keymap_normal("<leader>tts", ":Telescope treesitter<CR>")                -- Show Treesitter query results
        set_keymap_normal("<leader>tfz", ":Telescope current_buffer_fuzzy_find<CR>") -- Like it says

        -- CTags

        set_keymap_normal("<leader>ttg", ":Telescope tags<CR>")                 -- <CTags support>
        set_keymap_normal("<leader>tbtg", ":Telescope current_buffer_tags<CR>") -- <CTags support>

        -- Git

        set_keymap_normal("<leader>tgf", ":Telescope git_files<CR>")     -- Show files tracked by git
        set_keymap_normal("<leader>tgc", ":Telescope git_commits<CR>")   -- Show git commits
        set_keymap_normal("<leader>tbgc", ":Telescope git_bcommits<CR>") -- Show git commits for current buffer
        set_keymap_normal("<leader>tgb", ":Telescope git_branches<CR>")  -- Show git branches
        set_keymap_normal("<leader>tgs", ":Telescope git_status<CR>")    -- Show git status
        set_keymap_normal("<leader>tgh", ":Telescope git_stash<CR>")     -- Show git stash

        -- Telescope

        set_keymap_normal("<leader>tpp", ":Telescope git_builtin<CR>") -- Show pickers
        set_keymap_normal("<leader>trr", ":Telescope git_resume<CR>")  -- Resume last picker
        -- pickers
        -- planets
        -- symbols

        -- Neovim

        -- commands
        -- quickfix
        -- quickfixhistory
        -- loclist
        -- oldfiles
        -- command_history
        -- search_history
        -- vim_options
        -- help_tags
        -- man_pages
        -- reloader
        -- buffers
        -- colorscheme
        -- marks
        -- registers
        set_keymap_normal("<leader>tkm", ":Telescope keymaps<CR>") -- Show key mappings
        -- filetypes
        -- highlights
        -- autocommands
        -- spell_suggest
        -- tagstack
        -- jumplist

        -- LSP

        -- lsp_references
        -- lsp_incoming_calls
        -- lsp_outgoing_calls
        -- lsp_definitions
        -- lsp_type_definitions
        -- lsp_implementations
        -- lsp_document_symbols
        -- lsp_workspace_symbols
        -- lsp_dynamic_workspace_symbols

        -- ???

        -- diagnostics
    end,
}
