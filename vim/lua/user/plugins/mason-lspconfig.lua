-- It used to do a lot more, but since nvim v0.11, mason-lspconfig has been
-- reduced to merely arranging for installed LSP servers to be enabled on
-- startup. It also helps translate between the Mason and nvim-lspconfig names
-- for said servers.
--
-- From its README:
--
--      Since the introduction of :h vim.lsp.config in Neovim 0.11, this
--      plugin's feature set has been reduced. Use this plugin if you want to
--      automatically enable installed servers (:h vim.lsp.enable()) or have
--      access to the :LspInstall command.

return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        -- These dependencies are based on the following snippet from the
        -- mason-lspconfig 2.0 CHANGELOG:
        --
        --      require("mason").setup()
        --      require("mason-lspconfig").setup() -- Note: `nvim-lspconfig` needs to be in 'runtimepath' by the time you setup

        "neovim/nvim-lspconfig",
        "mason-org/mason.nvim"
    },
    opts = {},
}
