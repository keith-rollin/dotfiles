return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip"
    },
    config = function()
        local cmp = require("cmp")

        -- Suggested by nvim-cmp

        vim.opt.completeopt = { "menu", "menuone", "noselect" }

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
                ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                ["<Tab>"] = cmp.mapping.select_next_item(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                ["<ESC>"] = cmp.mapping.abort(),
            }),

            sources = {
                { name = "nvim_lsp" },
                { name = "vsnip" },
            },
        }

        cmp.setup(opts)
    end,
}
