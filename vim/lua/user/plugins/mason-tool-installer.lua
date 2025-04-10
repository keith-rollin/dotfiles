-- Mason Tool Installer arranges for the automatic installation of the external
-- tooling that Mason manages. Here, we simply specify the packages that we
-- want to install. The installation is performed automatically when the
-- `VimEnter` event is triggered.
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
        "williamboman/mason.nvim",           -- Required for base package downloading functionality.
        "williamboman/mason-lspconfig.nvim", -- Handy for translating from lspconfig names to Mason package names.
    },
    opts = {
        ensure_installed = {
            -- LSP servers

            "lua-language-server",
            "pyright", -- I keep this around only for symbol renaming.
            "ruff",
            "rust-analyzer",
            "swiftlint",

            -- Linters/formatters
            --
            -- I keep `isort` around to re-sort imports on save. Ruff will re-sort on
            -- demand, but doesn't seem to do that on save, and it doesn't do it right
            -- (it doesn't support isort's force_single_line option).
            "isort",
        },
    },
}
