return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "folke/which-key.nvim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("telescope").setup()

        local wk = require("which-key")
        wk.register({
            name = "Telescope",
            f = {
                "Find files",
                l = { "<cmd>Telescope live_grep<CR>", "Search open buffers" },
                g = { "<cmd>Telescope grep_string<CR>", "Search directory for hot string" },
                f = { "<cmd>Telescope find_files<CR>", "Search for files" },
                t = { "<cmd>Telescope treesitter<CR>", "Show Treesitter query results" },
                c = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "Like it says" },
            },

            t = {
                name = "Tags",
                t = { "<cmd>Telescope tags<CR>", "Ctags support" },
                c = { "<cmd>Telescope current_buffer_tags<CR>", "Ctags support" },
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
                b = { "<cmd>Telescope builtin" },
                r = { "<cmd>Telescope resume" },
            },

            k = { "<cmd>Telescope keymaps" },
        }, {
            mode = "n",
            prefix = "<leader>t",
        })
    end,
}
