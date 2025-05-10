return {
    settings = {
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
        -- https://luals.github.io/wiki/settings/
        Lua = {
            diagnostics = { enable = true, globals = { "vim", "kr" }, },
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
}
