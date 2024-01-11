return {
    -- Managing plugins for LSP, formatting, and linting is kind of a pain.
    --
    -- Mason is a pretty good tool for this, but it only gets you part of the
    -- way there. Mason knows about tons of plugins and how to load them, but
    -- it will only load them via its MasonInstall command. This command is not
    -- very friendly to run when executing startup Lua scripts since that
    -- command will bring up the "Installing..." dialog. It does have an API
    -- that will avoid this, but it's pretty inscrutable. Fortunately, there is
    -- a Github project called mason-tool-installer that takes care of working
    -- with this API.
    --
    -- For the most part, we can avoid this dialog by using mason-lspconfig and
    -- nvim-lspconfig. The latter can be used to load LSP plugins. But it will
    -- only load the set that it knows about. This set is a subset of what Mason
    -- supports. In particular, it only knows about LSP plugins, not anything
    -- about formatting or linting plugins. Wrapped around this is
    -- mason-lspconfig, which will take care of making sure that the set of
    -- plugins we require are automatically downloaded and will take care of
    -- initializing them when that's done. This all works pretty well, but --
    -- again -- it only works for LSP servers.
    --
    -- To handle the installing and initializing of non-LSP tools, we use
    -- null-ls. (NOTE: the original null-ls is no longer supported by its
    -- original author. His old project has been taken over by a new group and
    -- has been renamed to none-ls.nvim.) This tool can handle the installing
    -- and initializing very simply and magically makes these tools look like
    -- LSP servers to nvim, making their utilization consistent with the actual
    -- LSP servers. However, it doesn't do anything to download the formatters
    -- and linters. For that, we turn to mason-tool-installer.
    --
    -- In short:
    --
    -- * the LSP servers are specified in "ensure_installed", are downloaded by
    --   Mason, and are installed and initialized by a combination of
    --   nvim-lspconfig and mason-lspconfig,
    -- * the non-LSP servers are installed by mason-tool-installer,
    -- * the non-LSP servers are initialized by none-ls.nvim, null-ls, null_ls.
    --
    -- For reference, the list of everything that Mason can install through its
    -- UI and that mason-tool-installer can install is here:
    --
    --      https://github.com/mason-org/mason-registry/blob/main/packages/isort/package.yaml
    --
    -- The list of everything that mason-lspconfig can install through its
    -- ensure_installed facility is here:
    --
    --      https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/mappings/server.lua
    --
    -- The list of things that null-ls can initialize is here:
    --
    --      https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
    --
    -- Consider adding DAP support. See the following starting at 9:50:
    -- https://www.youtube.com/watch?v=4BnVeOUeZxc

    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    border = "double",
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "-",
                    },
                },
            })
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        config = function()
            -- Use Mason-lspconfig to install the LSP plugins
            --
            -- Fun fact: I was wondering why there was a 'handlers' field here
            -- to initialize the plugins when there was a perfectly fine
            -- mechanism for doing this in nvim-lspconfig. It turns out that the
            -- versions here are invoked after any plugins are downloaded and
            -- installed. If we were to put this configuration process in the
            -- nvim-lspconfig setup() function, it would be possible for that
            -- package to try to initialize the plugins before mason-lsp-config
            -- had finished loading them.

            local augroup = vim.api.nvim_create_augroup("formatting_group", {})

            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function(event)
                    local bufnr = event.buf

                    -- If the LSP supports formatting, set up a callback to
                    -- invoke it when the buffer is saved.

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr })
                            end,
                        })
                    else
                        -- nvim sets this to v:lua.vim.lsp.formatexpr(). This
                        -- has the effect of breaking 'gq' to reformat a range
                        -- if the associated LSP doesn't support formatting.
                        -- So, if that's the case, unset formatexpr to get back
                        -- the default behavior.
                        --
                        -- (Well, that's the theory, anyway. Unfortunately,
                        -- 'gq' still doesn't seem to work, for example, for
                        -- this Lua file. But it *does* restore functionality
                        -- to my .zshrc file.)

                        vim.bo[bufnr].formatexpr = nil
                    end

                    -- Set up some LSP-related shortcuts (perform code action,
                    -- go to definition, show references, etc.)

                    local opts = { noremap = true, silent = true, buffer = bufnr }
                    local bufmap = function(keys, fn)
                        vim.keymap.set("n", "<leader>" .. keys, fn, opts)
                    end

                    bufmap("K", vim.lsp.buf.hover)
                    bufmap("ca", vim.lsp.buf.code_action)
                    bufmap("do", vim.diagnostic.open_float)
                    bufmap("dp", vim.diagnostic.goto_prev)
                    bufmap("dn", vim.diagnostic.goto_next)
                    bufmap("dl", vim.diagnostic.setloclist)
                    bufmap("ff", vim.lsp.buf.format)
                    bufmap("gD", vim.lsp.buf.declaration)
                    bufmap("gd", vim.lsp.buf.definition)
                    bufmap("gi", vim.lsp.buf.implementation)
                    bufmap("gt", vim.lsp.buf.type_definition)
                    bufmap("rn", vim.lsp.buf.rename)
                    -- bufmap("sh", vim.lsp.buf.signature_help)
                    bufmap("sr", vim.lsp.buf.references)
                end,
            })

            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local default_opts = {
                capabilities = capabilities,
            }

            local function default_handler(server_name, opts)
                local merged_opts = vim.tbl_extend("keep", opts or {}, default_opts)
                lspconfig[server_name].setup(merged_opts)
            end

            require("mason-lspconfig").setup({
                ensure_installed = {

                    -- Understands your C++ code and adds smart features to
                    -- your editor: code completion, compile errors,
                    -- go-to-definition and more (https://clangd.llvm.org)

                    "clangd",

                    -- A language server that offers Lua language support -
                    -- programmed in Lua
                    -- (https://github.com/LuaLS/lua-language-server)

                    "lua_ls",

                    -- Static Type Checker for Python (from Microsoft)

                    "pyright",

                    -- rust-analyzer is an implementation of the Language
                    -- Server Protocol for the Rust programming language. It
                    -- provides features like completion and goto definition
                    -- for many code editors, including VS Code, Emacs and Vim
                    -- (https://github.com/rust-lang/rust-analyzer)

                    "rust_analyzer",
                },

                handlers = {
                    default_handler,

                    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
                    ["lua_ls"] = function()
                        default_handler("lua_ls", {
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        enable = true,
                                        globals = { "vim" },
                                    },
                                    format = {
                                        enable = true,
                                    },
                                },
                            },
                        })
                    end,

                },
            })
        end,
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "beautysh",
                    "ruff",
                    "black",
                    "isort",
                },
            })
        end,
    },

    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.diagnostics.ruff,
                    null_ls.builtins.formatting.beautysh,
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.isort,
                },
            })
        end,
    },
}
