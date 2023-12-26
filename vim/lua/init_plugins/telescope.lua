return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("telescope").setup()

        local utils = require("utils")

        -- Search for and in files

        utils.set_keymap_normal("<leader>tlg", ":Telescope live_grep<CR>") -- Search open buffers
        utils.set_keymap_normal("<leader>tgs", ":Telescope grep_string<CR>") -- Search directory for hot string
        utils.set_keymap_normal("<leader>tff", ":Telescope find_files<CR>") -- Search for files
        utils.set_keymap_normal("<leader>tts", ":Telescope treesitter<CR>") -- Show Treesitter query results
        utils.set_keymap_normal("<leader>tfz", ":Telescope current_buffer_fuzzy_find<CR>") -- Like it says

        -- CTags

        utils.set_keymap_normal("<leader>ttg", ":Telescope tags<CR>") -- <CTags support>
        utils.set_keymap_normal("<leader>tbtg", ":Telescope current_buffer_tags<CR>") -- <CTags support>

        -- Git

        utils.set_keymap_normal("<leader>tgf", ":Telescope git_files<CR>") -- Show files tracked by git
        utils.set_keymap_normal("<leader>tgc", ":Telescope git_commits<CR>") -- Show git commits
        utils.set_keymap_normal("<leader>tbgc", ":Telescope git_bcommits<CR>") -- Show git commits for current buffer
        utils.set_keymap_normal("<leader>tgb", ":Telescope git_branches<CR>") -- Show git branches
        utils.set_keymap_normal("<leader>tgs", ":Telescope git_status<CR>") -- Show git status
        utils.set_keymap_normal("<leader>tgh", ":Telescope git_stash<CR>") -- Show git stash

        -- Telescope

        utils.set_keymap_normal("<leader>tpp", ":Telescope git_builtin<CR>") -- Show pickers
        utils.set_keymap_normal("<leader>trr", ":Telescope git_resume<CR>") -- Resume last picker
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
        utils.set_keymap_normal("<leader>tkm", ":Telescope keymaps<CR>") -- Show key mappings
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

