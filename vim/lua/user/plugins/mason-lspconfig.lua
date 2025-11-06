-- From the README:
--
--      [mason-lspconfig]'s main responsibilities are to:
--
--      * allow you to (i) automatically install, and (ii) automatically enable
--        (vim.lsp.enable()) installed servers
--      * provide extra convenience APIs such as the :LspInstall command
--      * provide additional LSP configurations for a few servers
--      * translate between nvim-lspconfig server names and mason.nvim package names
--        (e.g. lua_ls <-> lua-language-server)
--
-- It's not apparent to me what "installed servers" means, but I think it's the
-- items in ~/.local/share/nvim/mason/packages/. Note that we don't use
-- mason-lspconfig to install our LSP servers; we use mason-tool-installer for
-- that.

return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
    opts = {},
}
