-- From the README:
--
--      mason.nvim is a Neovim plugin that allows you to easily manage external
--      editor tooling such as LSP servers, DAP servers, linters, and formatters
--      through a single interface. It runs everywhere Neovim runs (across
--      Linux, macOS, Windows, etc.), with only a small set of external
--      requirements needed.
--
--      Packages are installed in Neovim's data directory (:h standard-path) by
--      default. Executables are linked to a single bin/ directory, which
--      mason.nvim will add to Neovim's PATH during setup, allowing seamless
--      access from Neovim builtins (LSP client, shell, terminal, etc.) as well
--      as other 3rd party plugins.
--
-- It may be helpful to add the following:
--
-- * mason.nvim provides a UI for installing, removing, and updating the tooling
--   packages. This UI is invoked via the :Mason command.
--
-- * mason.nvim also provides the framework for downloading the tools. This
--   framework is used by mason-tool-installer. mason.nvim could use this
--   framework itself, but it only supports downloading LSP servers. We use
--   mason-tool-installer to extend that downloading support to non-LSP servers
--   (like linters and formatters).

return {
    "mason-org/mason.nvim",
    opts = {
        ui = {
            border = "double",
        },
    },
}
