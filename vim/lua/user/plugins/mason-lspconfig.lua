-- Mason-lspconfig arranges for the configuration of the LSP servers that Mason
-- manages. It does this by noting what LSP servers are installed and listening
-- for the installation of new servers. When a new server is installed, it will
-- be configured with the information here.

return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",   -- So we can call it to configure our LSP servers.
        "williamboman/mason.nvim", -- So we can call mason-core, mason-core.functional, etc.
    },
    config = function()
        local lspconfig = require("lspconfig")

        local function initialize_keymap()
            -- Set up an event handler to establish LSP-related key bindings
            -- when we enter a buffer that an LSP supports.

            kr.set_diagnostic_mapping()
            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function()
                    kr.set_lsp_mapping()
                end,
            })
        end

        local function initialize_mason_lspconfig()
            -- Establish some custom settings for our LSPs.

            local function create_default_handler()
                local nvim_cmp_capabilities = {} -- require("cmp_nvim_lsp").default_capabilities()
                local default_opts = {
                    capabilities = nvim_cmp_capabilities,
                }

                local function default_handler(server_name, opts)
                    local merged_opts = vim.tbl_extend(kr.keep_left, opts or {}, default_opts)

                    -- 'merged_opts' get installed into the 'config' field of
                    -- the client object described above. Hence, you would see
                    -- the cmp_nvim_lsp capabilities that were provided above in
                    -- client.config.capabilities.completion, and any 'settings'
                    -- provided below in client.config.settings.

                    lspconfig[server_name].setup(merged_opts)
                end

                return default_handler
            end

            local default_handler = create_default_handler()

            require("mason-lspconfig").setup({
                handlers = {
                    default_handler,

                    -- NB: The keys here need to be lspconfig server names, not
                    -- mason's package names.

                    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
                    -- https://luals.github.io/wiki/settings/

                    ["lua_ls"] = function()
                        default_handler("lua_ls", {
                            settings = {
                                Lua = {
                                    diagnostics = { enable = true, globals = { "vim", "spec", "kr" }, },
                                    format = { enable = true, },
                                    hint = { enable = true, },
                                    runtime = { special = { spec = "require", }, version = "LuaJIT", },
                                    workspace = {
                                        library = {
                                            [vim.env.VIMRUNTIME] = true,
                                            [vim.fn.stdpath("config")] = true,
                                        },
                                    },
                                },
                            },
                        })
                    end,

                    -- From https://github.com/astral-sh/ruff/blob/main/crates/ruff_server/docs/setup/NEOVIM.md

                    ["pyright"] = function()
                        default_handler("pyright", {
                            settings = {
                                pyright = {
                                    -- Using Ruff's import organizer
                                    disableOrganizeImports = true,
                                },
                                python = {
                                    analysis = {
                                        -- Ignore all files for analysis to exclusively use Ruff for linting
                                        -- ignore = { "*" },
                                    },
                                },
                            },
                        })
                    end,
                },
            })
        end

        local function initialize_sourcekit()
            -- Set up the sourcekit LSP server. This is used for Swift. Note
            -- that we can't install this via mason-lspconfig since that plugin
            -- doesn't know about sourcekit--it's already installed with swift.
            -- So we need to initialize it "out of band".
            --
            -- See: https://www.swift.org/documentation/articles/zero-to-swift-nvim.html
            --
            -- Note that that article may be a bit out of date. Under "File
            -- Updating", it recommends setting `dynamicRegistration` to true.
            -- However, the following nvim bug report indicates that nvim now
            -- supports dynamic registration:
            --
            -- https://github.com/neovim/nvim-lspconfig/issues/2807#issuecomment-1716433221
            --
            -- I've been running with `dynamicRegistration` set to false and it
            -- seems to be working fine.

            lspconfig.sourcekit.setup {}
        end

        initialize_keymap()
        initialize_mason_lspconfig()
        initialize_sourcekit()
    end,
}
