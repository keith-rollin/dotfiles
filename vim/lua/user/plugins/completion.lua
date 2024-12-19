return {
    "hrsh7th/nvim-cmp", -- Investigate blink.cmp (standalone, and part of blink.nvim). It seems like it might be too unstable at the moment.
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
                -- I'd like to use <TAB>/<S-TAB>, but they conflict with github-copilot.
                ["<Left"] = cmp.mapping.select_prev_item(),         -- Alias for <Up>
                ["<C-k"] = cmp.mapping.select_prev_item(),          -- Alias for <Up>
                ["<Right>"] = cmp.mapping.select_next_item(),       -- Alias for <Down>
                ["<C-j>"] = cmp.mapping.select_next_item(),         -- Alias for <Down>
                ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Alias for <C-y>
                ["<ESC>"] = cmp.mapping.abort(),                    -- Alias for <C-e>
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
