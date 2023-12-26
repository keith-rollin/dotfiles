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
            -- Fun fact: I was wondering why there was a 'handlers' field here to
            -- initialize the plugins when there was a perfectly fine mechanism for doing
            -- this in nvim-lspconfig. It turns out that the versions here are invoked
            -- after any plugins are downloaded and installed. If we were to put this
            -- configuration process in the nvim-lspconfig setup() function, it would be
            -- possible for that package to try to initialize the plugins before
            -- mason-lsp-config had finished loading them.

            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function(event)
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

                    -- Use something along these lines to unset 'formatexpr' if the LSP
                    -- does not support formatting. That way, maybe we'll get 'gq'
                    -- back.
                    --
                    -- vim.api.nvim_create_autocmd("LspAttach", {
                    --   callback = function(args)
                    --     local bufnr = args.buf
                    --     local client = vim.lsp.get_client_by_id(args.data.client_id)
                    --     if client.server_capabilities.completionProvider then
                    --       vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
                    --     end
                    --     if client.server_capabilities.definitionProvider then
                    --       vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
                    --     end
                    --   end,
                    -- })
                    --
                    -- To get the LSP server capabilities:
                    -- lua =vim.lsp.get_active_clients()[1].server_capabilities
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
                    -- understands your C++ code and adds smart features to
                    -- your editor: code completion, compile errors,
                    -- go-to-definition and more (https://clangd.llvm.org)

                    "clangd",

                    -- A language server that offers Lua language support -
                    -- programmed in Lua
                    -- (https://github.com/LuaLS/lua-language-server)

                    "lua_ls",

                    -- A fast static code analyzer & language server for Python
                    -- (https://github.com/mtshiba/pylyzer)
                    --
                    -- This is putting up some errors when I try to use it. And it's slow to build/install.
                    --
                    -- "pylyzer",

                    -- Fork of the python-language-server project, maintained
                    -- by the Spyder IDE team and the community
                    -- (https://github.com/python-lsp/python-lsp-server)

                    "pylsp",

                    -- A Language Server Protocol implementation for Ruff - An
                    -- extremely fast Python linter, written in Rust
                    -- (https://github.com/astral-sh/ruff-lsp/)

                    "ruff_lsp",

                    -- rust-analyzer is an implementation of the Language
                    -- Server Protocol for the Rust programming language. It
                    -- provides features like completion and goto definition
                    -- for many code editors, including VS Code, Emacs and Vim
                    -- (https://github.com/rust-lang/rust-analyzer)

                    "rust_analyzer",

                    -- Sourcery is a tool available in your IDE, GitHub, or as
                    -- a CLI that suggests refactoring improvements to help
                    -- make your code more readable and generally higher
                    -- quality (https://docs.sourcery.ai/)
                    --
                    -- This is putting up some errors when I try to use it.
                    --
                    -- "sourcery",
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
                                        globals = { "vim", "bufnr" },
                                    },
                                    -- For what it's worth...it doesn't give me 'gq' back...
                                    format = {
                                        enable = false,
                                    },
                                },
                            },
                        })
                    end,

                    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pylsp
                    --
                    -- Looks like pylsp automatically installs the following
                    -- support tools. This means that we don't need to
                    -- duplicate them elsewhere (like when configuring
                    -- formatter.nvim).
                    --
                    -- * autopep8
                    -- * flake8
                    -- * get_gprof
                    -- * get_objgraph
                    -- * isort
                    -- * isort-identify-imports
                    -- * pycodestyle
                    -- * pydocstyle
                    -- * pyflakes
                    -- * pylint
                    -- * pylint-config
                    -- * pylsp
                    -- * pyreverse
                    -- * symilar
                    -- * undill
                    -- * yapf
                    -- * yapf-diff

                    ["pylsp"] = function()
                        default_handler("pylsp", {
                            settings = {
                                pylsp = {
                                    plugins = {
                                        -- mccabe = {
                                        --     threshold = 100,
                                        -- },
                                        pycodestyle = {
                                            maxLineLength = 88, -- Match what ruff applies.
                                            ignore = {
                                                -- https://pycodestyle.pycqa.org/en/latest/intro.html#error-codes
                                                "E203", -- whitespace before ':' (fight between pyls and ruff)
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
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
            -- Use mason-tool-installer to download the non-LSP (formatting,
            -- linting) plugins
            --
            -- These are installed on VimEnter (that is, just after vim
            -- finishes starting up).

            require("mason-tool-installer").setup({
                ensure_installed = {
                    -- lua
                    "stylua",

                    -- python
                    "autoflake", -- Removes unused imports and unused variables as reported by pyflakes
                    "isort",
                    "ruff",

                    -- Loading rustfmt is deprecated. The :Mason dialog tells
                    -- us to use rustup (that is, the version that comes
                    -- standard with rust) instead.

                    -- rust
                    -- "rustfmt",

                    -- sh
                    "beautysh",
                },
            })
        end,
    },
    -- "mfussenegger/nvim-dap",
    -- "mfussenegger/nvim-lint",
    {
        -- Provides :Format[Write][Lock] commands, which can be used in Buf
        -- events or bound to <leader> keys. Does no formatting while typing;
        -- use LSP services for that. TODO: compare to stevearc/conform.nvim
        "mhartington/formatter.nvim",
        config = function()
            -- Use formatter.nvim to configure the formatting plugins
            --
            -- Formatting is done in response to :Format[Write][Lock] commands.
            -- We extend this by adding a BufWritePost handler to invoke
            -- FormatWrite. This approach is recommended by the formatting.nvim
            -- docs. It's not apparent to me why the documentation recommends
            -- this approach rather than calling Format on a BufWritePre hook.

            local filetypes_ok, _ = pcall(require, "formatter.filetypes")
            if not filetypes_ok then
                return
            end

            require("formatter").setup({
                filetype = {
                    lua = {
                        function()
                            -- Default: `stylua --search-parent-directories ...`
                            local cmd = require("formatter.filetypes.lua").stylua()
                            table.insert(cmd.args, 1, "--indent-type")
                            table.insert(cmd.args, 2, "Spaces")
                            return cmd
                        end,
                    },
                    python = {
                        require("formatter.filetypes.python").autoflake,
                        require("formatter.filetypes.python").isort,
                        require("formatter.filetypes.python").ruff,
                    },
                    rust = {
                        require("formatter.filetypes.rust").rustfmt,
                    },
                    zsh = {
                        require("formatter.filetypes.zsh").beautysh,
                    },

                    ["*"] = {
                        require("formatter.filetypes.any").remove_trailing_whitespace,
                    },
                },
            })

            require("utils").on_write_post({ "*.lua", "*.py", "*.rs", "*.sh", "*.bash", "*.zsh" }, function()
                -- Do we need format.nvim? Could we just use the LSP server?
                --      vim.lsp.buf.format({ async = false })
                vim.cmd("FormatWrite")
            end)
        end,
    },
}
