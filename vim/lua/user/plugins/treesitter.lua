return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                auto_install = true,
                indent = { enable = true },
                highlight = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<Enter>",
                        node_incremental = "<Enter>",
                        scope_incremental = false,
                        node_decremental = "<Backspace>",
                    },
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = { query = "@function.outer", desc = "Select outer part of a function region" },
                            ["if"] = { query = "@function.inner", desc = "Select inner part of a function region" },
                            ["ac"] = { query = "@comment.outer", desc = "Select outer part of a comment region" },
                            ["ic"] = { query = "@comment.inner", desc = "Select inner part of a comment region" },
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>sa"] = { query = "@parameter.inner", desc = "Swap with next parameter" },
                        },
                        swap_previous = {
                            ["<leader>sA"] = { query = "@parameter.inner", desc = "Swap with previous parameter" },
                        },
                    },
                    move = {
                        enable = false,
                    },
                    lsp_interop = {
                        enable = false,
                    },
                },
            })
        end
    }
}
