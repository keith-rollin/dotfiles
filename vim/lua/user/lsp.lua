-- Inspired by:
--
--      "How To Set Up LSP Natively in Neovim 0.11+"
--      https://www.youtube.com/watch?v=tdhxpn1XdjQ
--
-- See also:
--
--     "I Migrated to Neovim 0.12 VimPack So You Don't Have To"
--     https://youtu.be/h1sCwi0pNyM?si=4z4vtsOFkpybjZKn&t=647
--
-- All of the servers and other tools are installed outside of Neovim using
-- Homebrew.

vim.lsp.config("lua_ls", {
    settings = {
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
        -- https://luals.github.io/wiki/settings/
        Lua = {
            format = { enable = true, },
            hint = { enable = true, },
            runtime = { special = { spec = "require", }, version = "LuaJIT", },
            diagnostics = {
                disable = { "duplicate-set-field" }
            },
            workspace = {
                library = {
                    -- Tell lua_ls where to find all the Lua files that you have
                    -- loaded for your Neovim configuration.
                    --
                    -- From "The Only Video You Need to Get Started with Neovim"
                    --      https://youtu.be/m8C0Cq9Uv9o?t=1416
                    --
                    -- This seems to also take care of the problem where the
                    -- symbol "vim" is not recognized in Lua files and flagged
                    -- with underlined squiggles.
                    "${3rd}/luv/library",
                    unpack(vim.api.nvim_get_runtime_file("", true)),
                },
            },
        },
    },
})

vim.lsp.config("pyright", {
    settings = {
        -- From https://github.com/astral-sh/ruff/blob/main/crates/ruff_server/docs/setup/NEOVIM.md
        pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
        },
    },
})

vim.lsp.enable('lua_ls')        -- Downloaded via install.brew
vim.lsp.enable('pyright')       -- Downloaded via install.brew
vim.lsp.enable('ruff')          -- Downloaded via install.brew
vim.lsp.enable('rust_analyzer') -- Downloaded via `rustup`
vim.lsp.enable('sourcekit')     -- Downloaded via CommandLineTools

--
--
