-- Mason-lspconfig arranges for the configuration of the LSP servers that Mason
-- manages. It does this by noting what LSP servers are installed and listening
-- for the installation of new servers. When a new server is installed, it will
-- be configured with the information here.

vim.lsp.config('lua_ls', {
    settings = {
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
        -- https://luals.github.io/wiki/settings/
        Lua = {
            diagnostics = { enable = true, globals = { "vim", "spec", "kr" }, },
            format = { enable = true, },
            hint = { enable = true, },
            runtime = { special = { spec = "require", }, version = "LuaJIT", },
            workspace = {
                library = {
                    [vim.env.VIMRUNTIME] = true,
                    [vim.fn.stdpath("config")] = true,
                },
            },
        },
    },
})

vim.lsp.config('pyright', {
    settings = {
        -- From https://github.com/astral-sh/ruff/blob/main/crates/ruff_server/docs/setup/NEOVIM.md
        pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
        },
        python = {
            analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                -- ignore = { "*" },
            },
        },
    },
})

return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "williamboman/mason.nvim"
    },
    opts = {},
}
