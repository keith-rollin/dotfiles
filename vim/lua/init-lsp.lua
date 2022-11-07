-- Configure LSP
--
-- Consider using williamboman/nvim-lsp-installer
-- (NOTE: "Additional Requirements" may be prohibitive.)
--

local cmp_status_ok, cmp = pcall(require, "cmp")
local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local lsp_config_status_ok, lsp_config = pcall(require, "lsp_config")
if not (cmp_status_ok and cmp_nvim_lsp_status_ok and lsp_config_status_ok) then
    return
end

cmp.setup({

    -- vim-cmp and cmp-nvim-lsp configuration from:
    --
    --      https://github.com/hrsh7th/nvim-cmp

    mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        ["<LEFT>"] = cmp.mapping.select_prev_item(),
        ["<RIGHT>"] = cmp.mapping.select_next_item(),
        ["<UP>"] = cmp.mapping.select_prev_item(),
        ["<DOWN>"] = cmp.mapping.select_next_item(),

        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-SPACE>"] = cmp.mapping.complete(),
        ["<ESC>"] = cmp.mapping.close(),
    },

    -- Note that we can set attributes for each source:
    --
    --  * keyword_length
    --  * priority
    --  * max_item_count
    --  * (others?)

    sources = {
        { name = "nvim_lsp" },
        { name = "buffer", keyword_length = 3 },
        { name = "path" },
        { name = "cmdline" },
        { name = "vsnip" },
    },

    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
})

local capabilities = cmp_nvim_lsp.default_capabilities()

-- Establish LSP mappings from:
--
--   https://github.com/neovim/nvim-lspconfig
--

local do_map = function(keys, fn)
    vim.api.nvim_keymap_set("n", "<leader>" .. keys, fn, { noremap = true, silent = true })
end
do_map("dn", vim.diagnostic.goto_prev)
do_map("dp", vim.diagnostic.goto_next)

vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")

local on_attach = function(client, bufnr)
    local do_map = function(keys, fn)
        vim.api.nvim_keymap_set("n", "<leader>" .. keys, fn, { noremap = true, silent = true, buffer = bufnr })
    end
    do_map("gd", vim.lsp.buf.definition)
    do_map("gi", vim.lsp.buf.implementation)
    do_map("gt", vim.lsp.buf.type_definition)
    do_map("sr", vim.lsp.buf.references)
    do_map("sh", vim.lsp.buf.signature_help)
    do_map("K", vim.lsp.buf.hover)
    do_map("rn", vim.lsp.buf.rename)
    do_map("ff", vim.lsp.buf.formatting)
    do_map("ca", vim.lsp.buf.code_action)
end

-- I'm told we don't need this if we're using rust-tools (below).
-- Note that the keyboard mappings defined above and established below are
-- moved to the rust-tools initialization block.

if false then
    lspconfig.rust_analyzer.setup({
        on_attach = on_attach,
        capabilities = capabilities,

        -- Server-specific settings...
        --    settings = {
        --    ["rust-analyzer"] = {}
        --    }
    })
end

lspconfig.pylsp.setup({
    on_attach = on_attach,
    capabilities = capabilities,

    --
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pylsp
    --
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = {
                        -- https://pycodestyle.pycqa.org/en/latest/intro.html#error-codes
                        "E221", -- multiple spaces before operator
                        "W503", -- line break before binary operator
                        "W504", -- line break after binary operator
                    },
                },
            },
        },
    },
})
