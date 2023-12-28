return {

    -- Management of LSP, DAP, lint, and formatting tools

    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
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
                                vim.lsp.buf.format({ async = false, bufnr = bufnr })
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

                    local bufmap = function(keys, fn)
                        local opts = { noremap = true, silent = true, buffer = event.buf }
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

            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")

            local function default_handler(server_name, opts)
                local default_opts = {
                    capabilities = capabilities,
                }
                local merged_opts = vim.tbl_extend("keep", opts or {}, default_opts)
                lspconfig[server_name].setup(merged_opts)
            end

            require("mason-lspconfig").setup({
                ensure_installed = {

                    -- A language server for Bash.

                    "bashls",

                    -- Understands your C++ code and adds smart features to
                    -- your editor: code completion, compile errors,
                    -- go-to-definition and more (https://clangd.llvm.org)

                    "clangd",

                    -- A language server that offers Lua language support -
                    -- programmed in Lua
                    -- (https://github.com/LuaLS/lua-language-server)

                    "lua_ls",

                    -- Fork of the python-language-server project, maintained
                    -- by the Spyder IDE team and the community
                    -- (https://github.com/python-lsp/python-lsp-server)

                    "pylsp",

                    -- rust-analyzer is an implementation of the Language
                    -- Server Protocol for the Rust programming language. It
                    -- provides features like completion and goto definition
                    -- for many code editors, including VS Code, Emacs and Vim
                    -- (https://github.com/rust-lang/rust-analyzer)

                    "rust_analyzer",
                },

                handlers = {
                    default_handler,

                    ["bashls"] = function()
                        default_handler("bashls", {
                            filetypes = { 'zsh' },
                        })
                    end,

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

                    -- Things we can configure to varying degrees:
                    --
                    -- - [Jedi](https://github.com/davidhalter/jedi) to provide Completions, Definitions, Hover, References, Signature Help, and Symbols
                    -- - [Rope](https://github.com/python-rope/rope) for Completions and renaming
                    -- - [Pyflakes](https://github.com/PyCQA/pyflakes) linter to detect various errors
                    -- - [McCabe](https://github.com/PyCQA/mccabe) linter for complexity checking
                    -- - [pycodestyle](https://github.com/PyCQA/pycodestyle) linter for style checking
                    -- - [pydocstyle](https://github.com/PyCQA/pydocstyle) linter for docstring style checking (disabled by default)
                    -- - [autopep8](https://github.com/hhatto/autopep8) for code formatting
                    -- - [YAPF](https://github.com/google/yapf) for code formatting (preferred over autopep8)
                    -- - [flake8](https://github.com/pycqa/flake8) for error checking (disabled by default)
                    -- - [pylint](https://github.com/PyCQA/pylint) for code linting (disabled by default)
                    --
                    -- √ autopep8
                    --   flake8
                    -- √ jedi_completion
                    -- √ jedi_hover
                    -- √ jedi_references
                    -- √ jedi_signature_help
                    -- √ jedi_symbols
                    -- √ mccabe
                    -- √ preload
                    -- √ pycodestyle
                    --   pydocstyle
                    -- √ pyflakes
                    --   pylint
                    --   rope_autoimport
                    -- √ rope_autoimport.completions
                    -- √ rope_autoimport.code_actions
                    --   rope_completion
                    -- √ yapf

                    ["pylsp"] = function()
                        default_handler("pylsp", {
                            settings = {
                                pylsp = {
                                    plugins = {
                                        rope_autoimport = {
                                            enabled = true,
                                        },
                                        rope_completion = {
                                            enabled = true,
                                        },
                                        pycodestyle = {
                                            maxLineLength = 88, -- Something is formatting us to 88 characters, so don't complain about it
                                            ignore = {
                                                -- https://pycodestyle.pycqa.org/en/latest/intro.html#error-codes
                                                "E221", -- multiple spaces before operator
                                                "E241", -- multiple spaces after ':'
                                                "W503", -- line break before binary operator
                                                "W504", -- line break after binary operator
                                            },
                                        },
                                    },
                                },
                            },
                        })
                    end,
                },
            })
        end,
    },
}
