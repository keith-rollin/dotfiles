return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        -- "hrsh7th/cmp-buffer",
        -- "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        -- "hrsh7th/cmp-nvim-lua",
        -- "hrsh7th/cmp-path",
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

        local select_opts = { behavior = cmp.SelectBehavior.Select }

        local opts = {

            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),

                ["<LEFT>"] = cmp.mapping.select_prev_item(),
                ["<RIGHT>"] = cmp.mapping.select_next_item(),
                -- These are part of the presets
                -- ["<UP>"] = cmp.mapping.select_prev_item(),
                -- ["<DOWN>"] = cmp.mapping.select_next_item(),

                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<C-SPACE>"] = cmp.mapping.complete(),
                -- ["<ESC>"] = cmp.mapping.close(),
                ["<ESC>"] = cmp.mapping.abort(),

                ["<Tab>"] = cmp.mapping(function(fallback)
                    local col = vim.fn.col(".") - 1
                    if cmp.visible() then
                        cmp.select_next_item(select_opts)
                    elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
                        fallback()
                    else
                        cmp.complete()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item(select_opts)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),

            sources = {
                { name = "nvim_lsp" },
                { name = "vsnip" },
                -- { name = "buffer", keyword_length = 3 },
                -- { name = "cmdline" },
                -- { name = "nvim_lua" },
                -- { name = "path" },
            },
        }

        cmp.setup(opts)
    end,
}
