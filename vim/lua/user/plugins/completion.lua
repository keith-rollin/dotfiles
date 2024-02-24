return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "folke/which-key.nvim",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip",
    },
    config = function()
        local cmp = require("cmp")

        -- To find out about options, see:
        --
        --      https://github.com/hrsh7th/nvim-cmp/blob/main/doc/cmp.txt
        --      (search for *cmp-config*)
        --
        -- Or run :help cmp-config

        local opts = {

            snippet = {
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body)
                end,
            },

            mapping = cmp.mapping.preset.insert({
                -- These conflict with github-copilot. Let's rely on the default
                -- Up/Down handlers for now.
                -- ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                -- ["<Tab>"] = cmp.mapping.select_next_item(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                ["<ESC>"] = cmp.mapping.abort(),
            }),

            sources = {
                { name = "nvim_lsp" },
                -- { name = "buffer" },
                -- { name = "cmdline" },
                { name = "nvim_lua" },
                { name = "path" },
                { name = "vsnip" },
            },

            window = {
                completion = {
                    border = "double",
                },
                documentation = {
                    border = "double",
                },
            },
        }

        cmp.setup(opts)
    end,
}
