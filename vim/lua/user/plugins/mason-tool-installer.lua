-- From the README:
--
--      Install or upgrade all of your third-party tools.
--
--      Can run at startup or may be run manually via a command.
--
--      Uses Mason to do nearly all the work. This is a simple plugin that helps
--      users keep up-to-date with their tools and to make certain they have a
--      consistent environment.
--
-- As such, we merely list the tools we want installed at 'VimEnter' time.
-- mason-tool-installer takes care of the rest.
--
-- The names used here are the canonical Mason names, as shown on the right hand
-- side of:
--
--      https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/mappings/server.lua
--
-- Or in the contents of:
--
--      https://github.com/mason-org/mason-registry/tree/main/packages

return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
        "mason-org/mason.nvim",           -- Required for base package downloading functionality.
        "mason-org/mason-lspconfig.nvim", -- Handy for translating from lspconfig names to Mason package names.
    },
    opts = {
        ensure_installed = {
            -- LSP servers

            "lua-language-server",
            "pyright", -- I keep this around only for symbol renaming.
            "ruff",
            "rust-analyzer",

            -- Linters/formatters
            --
            -- I keep `isort` around to re-sort imports on save. Ruff will re-sort on
            -- demand, but doesn't seem to do that on save, and it doesn't do it right
            -- (it doesn't support isort's force_single_line option).
            "isort",
        },
    },
}
