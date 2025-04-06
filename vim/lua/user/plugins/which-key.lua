return {
    "folke/which-key.nvim",
    config = function()
        local wk = require("which-key")

        wk.setup({
            delay = function()
                return 400
            end,
            win = {
                border = "double",
            },
            spec = {
                { "<leader>S",  group = "Split Management" },
                { "<leader>c",  group = "Copilot" },
                { "<leader>d",  group = "Diagnostics" },
                { "<leader>e",  group = "Edit" },
                { "<leader>i",  group = "Info" },
                { "<leader>l",  group = "LSP" },
                { "<leader>n",  group = "netrw" },
                { "<leader>s",  group = "Toggle Settings" },
                { "<leader>t",  group = "Telescope" },
                { "<leader>x",  group = "Toggle" },
                { "<leader>t",  group = "Telescope" },
                { "<leader>tf", group = "Find Files" },
                { "<leader>tl", group = "LSP" },
                { "<leader>tt", group = "Tags" },
                { "<leader>tg", group = "git" },
                { "<leader>tp", group = "Pickers" },
            },
        })
    end,
}
