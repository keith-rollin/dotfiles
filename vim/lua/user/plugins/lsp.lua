-- Managing plugins for LSP, formatting, and linting is kind of a pain.
--
-- Mason is a pretty good tool for this, but it only gets you part of the way
-- there. Mason knows about tons of plugins and how to load them, but it will
-- only load them via its MasonInstall command. This command is not very
-- friendly to run when executing startup Lua scripts since that command will
-- bring up the "Installing..." dialog. It does have an API that will avoid
-- this, but it's pretty inscrutable. Fortunately, there is a Github project
-- called mason-tool-installer that takes care of working with this API.
--
-- For the most part, we can avoid this dialog by using mason-lspconfig and
-- nvim-lspconfig. The latter can be used to load LSP plugins. But it will only
-- load the set that it knows about. This set is a subset of what Mason
-- supports. In particular, it only knows about LSP plugins, not anything about
-- formatting or linting plugins. Wrapped around this is mason-lspconfig, which
-- will take care of making sure that the set of plugins we require are
-- automatically downloaded and will take care of initializing them when that's
-- done. This all works pretty well, but -- again -- it only works for LSP
-- servers.
--
-- To handle the installing and initializing of non-LSP tools, we use null-ls.
-- (NOTE: the original null-ls is no longer supported by its original author.
-- His old project has been taken over by a new group and has been renamed to
-- none-ls.nvim.) This tool can handle the installing and initializing very
-- simply and magically makes these tools look like LSP servers to nvim, making
-- their utilization consistent with the actual LSP servers. However, it doesn't
-- do anything to download the formatters and linters. For that, we turn to
-- mason-tool-installer.
--
-- In short:
--
-- * the LSP servers are specified in "ensure_installed", are downloaded by
--   Mason, and are initialized by a combination of nvim-lspconfig and
--   mason-lspconfig,
-- * the non-LSP servers are downloaded by mason-tool-installer,
-- * the non-LSP servers are initialized by none-ls.nvim, null-ls, null_ls.
--
-- For reference, the list of everything that Mason can install through its UI
-- and that mason-tool-installer can install is here:
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
--
--      https://www.youtube.com/watch?v=4BnVeOUeZxc
--
-- and
--
--      https://www.youtube.com/watch?v=oYzZxi3SSnM

-- https://www.youtube.com/live/KGJV0n70Mxs?si=yzKH6oWxE8TfPH1S&t=5600
--
local LSP_SERVERS = {
    "clangd",
    "lua_ls",
    "pyright",
    "rust_analyzer",
}

local NON_LSP_SERVERS = {
    "beautysh",
    "black",
    "isort",
    "ruff",
    "stylua",
}

return {
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
            "folke/which-key.nvim",
            "hrsh7th/nvim-cmp",
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
        },
        config = function()
            -- Set up an event handler to establish LSP-related key bindings
            -- when we enter a buffer that an LSP supports.

            local function initialize_keymap()
                kr.mapping.set_normal_leader({
                    name = "Diagnostics",
                    d = {
                        l = { vim.diagnostic.setloclist, "Set location list" },
                        n = { vim.diagnostic.goto_next, "Go to next diagnostic" },
                        o = { vim.diagnostic.open_float, "Show diagnostics" },
                        p = { vim.diagnostic.goto_prev, "Go to previous diagnostic" },
                    },
                })

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
                                callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end,
                            })
                        else
                            -- nvim sets the buffer option 'formatexpr' to
                            -- v:lua.vim.lsp.formatexpr(). This has the effect
                            -- of breaking 'gq' to reformat a range if the
                            -- associated LSP doesn't support formatting. So, if
                            -- that's the case, unset formatexpr to get back the
                            -- default behavior.
                            --
                            -- (Well, that's the theory, anyway. Unfortunately,
                            -- 'gq' still doesn't seem to work, for example, for
                            -- this Lua file. But it *does* restore
                            -- functionality to my .zshrc file.)

                            vim.bo[bufnr].formatexpr = nil
                        end

                        -- Set up some LSP-related shortcuts (perform code
                        -- action, go to definition, show references, etc.)

                        kr.mapping.set_normal_leader({
                            name = "LSP",
                            l = {
                                c = { vim.lsp.buf.code_action, "Code action" },
                                D = { vim.lsp.buf.declaration, "Go to declaraction" },
                                d = { vim.lsp.buf.definition, "Go to definition" },
                                f = { vim.lsp.buf.format, "Format file" },
                                h = { vim.lsp.buf.hover, "Display information about symbol under cursor" },
                                i = { vim.lsp.buf.implementation, "Go to implementation" },
                                r = { vim.lsp.buf.references, "Show references" },
                                s = { vim.lsp.buf.signature_help, "Show signature help" },
                                t = { vim.lsp.buf.type_definition, "Go to type definition" },
                            },
                            r = { vim.lsp.buf.rename, "LSP rename" },
                        })
                    end,
                })
            end

            -- Create the default handler for initializing LSP plugins. This
            -- handler -- for now -- lets LSP plugins know that we have an
            -- external completion handler (nvim-cmp + cmp_nvim_lsp) that they
            -- can take advantage of.
            --
            -- Note that this function *references* nvim-lspconfig, but it
            -- doesn't do anything to initialize it (it doesn't need any) or
            -- invoke any of its abilities. It just creates and returns a
            -- function that will invoke it later.

            local function create_default_handler()
                local lspconfig = require("lspconfig")
                local nvim_cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
                local default_opts = {
                    capabilities = nvim_cmp_capabilities,
                }

                local function default_handler(server_name, opts)
                    local merged_opts = vim.tbl_extend("keep", opts or {}, default_opts)
                    lspconfig[server_name].setup(merged_opts)
                end

                return default_handler
            end

            -- Initialize mason-lspconfig, telling it what LSP plugins we want
            -- and providing any custom configuration for them.
            --
            -- Fun fact: I was wondering why there was a 'handlers' field here
            -- to initialize the plugins when there was a perfectly fine
            -- mechanism for doing this in nvim-lspconfig. It turns out that the
            -- versions here are invoked after any plugins are downloaded and
            -- installed. If we were to put this configuration process in the
            -- nvim-lspconfig setup() function, it would be possible for that
            -- package to try to initialize the plugins before mason-lsp-config
            -- had finished loading them.

            local function initialize_mason_lspconfig(default_handler)
                require("mason-lspconfig").setup({
                    ensure_installed = LSP_SERVERS,
                    handlers = {
                        default_handler,

                        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
                        -- https://luals.github.io/wiki/settings/
                        ["lua_ls"] = function()
                            default_handler("lua_ls", {
                                settings = {
                                    Lua = {
                                        diagnostics = {
                                            enable = true,
                                            globals = { "vim", "spec" },
                                        },
                                        format = {
                                            enable = true,
                                        },
                                        hint = {
                                            enable = true,
                                        },
                                        runtime = {
                                            special = {
                                                spec = "require",
                                            },
                                            version = "LuaJIT",
                                        },
                                        workspace = {
                                            library = {
                                                [vim.env.VIMRUNTIME .. "/lua"] = true,
                                                [vim.fn.stdpath("config") .. "lua"] = true,
                                            },
                                        },
                                    },
                                },
                            })
                        end,
                    },
                })
            end

            initialize_keymap()
            local default_handler = create_default_handler()
            initialize_mason_lspconfig(default_handler)
        end,
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = NON_LSP_SERVERS,
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
                    null_ls.builtins.formatting.beautysh,
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.isort,
                    null_ls.builtins.formatting.stylua.with({
                        extra_args = {
                            "--indent-type",
                            "Spaces",
                            "--collapse-simple-statement",
                            "Always",
                        },
                    }),
                },
            })
        end,
    },
}
