return {
    -- Investigate blink.cmp:
    --
    --      https://github.com/Saghen/blink.cmp
    --      https://cmp.saghen.dev.

    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-path",
    },
    config = function()
        local cmp = require("cmp")

        local opts = {
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "nvim_lua" },
                { name = "path" },
            }, {
                { name = 'buffer' },
            }),
        }

        cmp.setup(opts)
    end,
}
