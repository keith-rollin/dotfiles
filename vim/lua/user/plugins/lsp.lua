-- Managing plugins for LSP, formatting, and linting is kind of a pain.
--
-- Managing a plugin involves two steps:
--
--  * Downloading/installing the plugin so that it's available somewhere in your
--    environment.
--  * Initializing/configuring/setting up the plugin by invoking its setup()
--    function or equivalent.
--
-- Mason is a pretty good tool for downloading/installing, but it only gets you
-- part of the way there. Mason knows about tons of plugins and how to load
-- them, but it will only load them via its API or its MasonInstall command. The
-- command is not very friendly to run when executing startup Lua scripts since
-- that command will bring up the "Installing..." dialog. The API will avoid
-- this, but it's pretty inscrutable. More on this later.
--
-- One Mason has downloaded/installed the tools that we've specified, we need to
-- initialize/configure/setup those tools. The nvim-lspconfig provides some help
-- in this area. It contains information on how to utilize most known/major LSP
-- servers. For the most part, the configuration information it provides is
-- sufficient out-of-the-box. However, the user may want to provide their own
-- customizations to these configurations (for example, I need to tell lua_ls
-- that "vim" is a special global variable). When using nvim-lspconfig to
-- configure our tools, it provides a mechanism for doing this.
--
-- However, we can't just naively invoke nvim-lspconfig to configure our tools.
-- Since Mason downloads the tools asynchronously, it's possible that the tools
-- have not yet downloaded when we try to configure them. Therefore, we need to
-- make use of mason-lspconfig, which provides support for this issue.
-- mason-lspconfig will make sure that any downloads have completed, and will
-- then arrange for the tools to finally be configured. This configuration is
-- achieved by setting mason-lspconfig up with configuration 'handlers'. These
-- handlers -- one per tool that we've installed -- are invoked by
-- mason-lspconfig when the tools can safely be configured.
--
-- mason-lspconfig also arranges to kick off the downloading of the tools via
-- Mason. This is done by listing the tools you want installed in a
-- mason-lspconfig configuration setting called 'ensure_installed'.
-- Unfortunately, only actual LSP servers can be specified in
-- 'ensure_installed'. Attempting to include any of the other non-LSP servers
-- that Mason knows about in this list will result in an error at startup saying
-- "Server Foo is not a valid entry in ensure_installed. Make sure to only
-- provide lspconfig server names." This leaves us with our not being able to
-- automatically download non-LSP servers when using mason-lspconfig.
--
-- To make up for this lack, we use mason-tool-installer. This plugin can be
-- configured with any list of tools to install -- both LSP and non-LSP.
-- mason-tool-installer is basically a simple loop that schedules the required
-- set of tools to be installed via Mason's API.
--
-- Once the tools are installed, as mentioned, mason-lspconfig will arrange for
-- the LSP servers to be configured via the 'handlers' we've registered with it.
-- But it doesn't have support for configuring the non-LSP servers. (Or does it?
-- I may need to investigate that.) Therefore, we use a tool called null-ls to
-- take care of that. (NOTE: the original null-ls is no longer supported by its
-- original author. His old project has been taken over by a new group and has
-- been renamed to none-ls.nvim.)
--
-- For reference, the list of everything that Mason can install through its UI
-- and that mason-tool-installer can install via Mason's API is here:
--
--      https://github.com/mason-org/mason-registry/tree/main/packages
--
-- The list of everything that mason-lspconfig can install through its
-- ensure_installed facility is here (the string to specify is the left-hand
-- one):
--
--      https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/mappings/server.lua
--
-- The list of things that null-ls can initialize is here:
--
--      https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md

local ENSURE_INSTALLED = {
    -- All of these are loaded via mason-tool-installer. The names used here are
    -- the canonical Mason names, as shown on the right hand side of:
    --
    --      https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/mappings/server.lua
    --
    -- Or in the contents of:
    --
    --      https://github.com/mason-org/mason-registry/tree/main/packages

    -- LSP servers, handled by mason

    "lua-language-server",
    "pyright",  -- I keep this around only for symbol renaming.
    "rust-analyzer",
    "ruff-lsp", -- NOTE: it's possible to install `ruff` via Mason, but I'm opting to do it via homebrew.

    -- DAP servers, handled by nvim-dap

    "debugpy",

    -- Linters/formatters, handled by none-ls

    "beautysh",
    "isort", -- I keep this around to re-sort on save (ruff will re-sort on demand, but doesn't seem to do that on save).
    "stylua",
}

return {
    {
        "williamboman/mason.nvim",
        opts = {
            ui = {
                border = "double",
                keymaps = {
                    apply_language_filter = "f",
                    toggle_help = "?",
                },
            },
        },
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "folke/which-key.nvim",    -- So we can establish associated key bindings.
            "hrsh7th/nvim-cmp",        -- So we can hook in code completion.
            "neovim/nvim-lspconfig",   -- So we can call it to configure our LSP servers.
            "williamboman/mason.nvim", -- So mlsp can call mason-core, mason-core.functional, etc.
        },
        config = function()
            -- Set up an event handler to establish LSP-related key bindings
            -- when we enter a buffer that an LSP supports.

            local function initialize_keymap()
                kr.mapping.set_normal({
                    name = "Diagnostics",
                    d = {
                        l = { vim.diagnostic.setloclist, "Set location list" },
                        n = { vim.diagnostic.goto_next, "Go to next diagnostic" },
                        o = { vim.diagnostic.open_float, "Show diagnostics" },
                        p = { vim.diagnostic.goto_prev, "Go to previous diagnostic" },
                    },
                }, { prefix = "<leader>" })

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
                                desc = "Format on save",
                                group = augroup,
                                buffer = bufnr,
                                callback = function()
                                    vim.lsp.buf.format({ bufnr = bufnr })
                                end,
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

                        kr.mapping.set_normal({
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
                        }, { prefix = "<leader>", buffer = bufnr })
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
                    local merged_opts = vim.tbl_extend(kr.keep_left, opts or {}, default_opts)
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
                                            globals = { "vim", "spec", "kr" },
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
            "williamboman/mason.nvim",           -- Required for base package downloading functionality.
            "williamboman/mason-lspconfig.nvim", -- Handy for translating from lspconfig names to Mason package names.
        },

        -- Package downloading is actually handled on the VimEnter event.

        opts = {
            ensure_installed = ENSURE_INSTALLED,
        },
    },

    -- At the time of this writing, the maintainer of none-ls is removing
    -- support for many plugins. It's not apparent why he's doing this, but it's
    -- affected me in that I now have to get beautysh from none-ls-extras.nvim.
    -- Instead, I may want to move to https://github.com/stevearc/conform.nvim.
    -- It supports the plugins I currently use.
    --
    -- Others to investigate:
    --
    --      * formatter.nvim
    --      * nvim-lint (https://github.com/mfussenegger/nvim-lint)
    --      * efm-langserver (https://github.com/mattn/efm-langserver with
    --        https://github.com/creativenull/efmls-configs-nvim)

    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- Documented requirement.
            "nvimtools/none-ls-extras.nvim", -- For beautysh.
        },

        -- This will register the formatters and linters that we want to use.
        -- Nothing will actually happen until a file of the matching type is
        -- opened.
        --
        -- (Since mason-tool-installer doesn't actually download the tools until
        -- the VimEnter event, we may end up in a situation where we try to use
        -- one of the following tools before they're available. This will lead
        -- to a rough startup, but it should only happen rarely/once.)
        --
        -- (NB: I tried setting this up as a simple 'opts' attribute, but I got
        -- errors trying to resolve the 'require("none-ls...")' statement.)

        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    require("none-ls.formatting.beautysh"),
                    null_ls.builtins.formatting.isort,
                    null_ls.builtins.formatting.stylua.with({
                        extra_args = {
                            "--indent-type",
                            "Spaces",
                        },
                    }),
                },
            })
        end,
    },
}
