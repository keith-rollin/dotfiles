--
-- * Use lazy.nvim to load extensions NOT related to LSP, formatting, linting,
--   etc. These extensions are automatically initialized by calling their
--   setup() methods. In special cases, we have custom initialization to pass
--   configuration information or perform other setup.
-- * Then use various routines to initialize mason, et al, to download,
--   configure, and activate those LSP, formatting, and linting tools.
--
-- Some handy helper material:
--
-- https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/
-- https://github.com/VonHeikemen/lsp-zero.nvim
-- https://github.com/VonHeikemen/nvim-starter
-- https://github.com/folke/lazy.nvim
--
-- TODO: When starting up from scratch, some repositories are successfully
--       cloned, but then block at some point (during checkout?). Why is this
--       happening?
-- TODO: Investigate the plugins referenced on the lazy.nvim github page.
--       Re-evaluate the plugins I use below. It's been a while since I added
--       them to my lists. Are they still the cutting edge, or have they been
--       superseded?
--
-- More plugins to investigate, including those for rust integration:
--      https://github.com/cpow/cpow-dotfiles
--      https://github.com/ChristianChiarulli/nvim
--

local function init_lazy()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)

    require("lazy").setup({
        spec = {
            -- Pre-reqs for a lot of other plugins.
            "nvim-lua/plenary.nvim",
            "nvim-lua/popup.nvim",

            "ConradIrwin/vim-bracketed-paste",
            "derekwyatt/vim-fswitch",
            "nvim-telescope/telescope.nvim",
            { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
            "nvim-treesitter/playground",
            "tpope/vim-commentary", -- TODO: Compare to https://github.com/tomtom/tcomment_vim and https://github.com/numToStr/Comment.nvim
            "tpope/vim-sensible",

            -- Completion
            "hrsh7th/nvim-cmp",
            -- "hrsh7th/cmp-buffer",
            -- "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp",
            -- "hrsh7th/cmp-nvim-lua",
            -- "hrsh7th/cmp-path",

            -- Management of LSP, DAP, lint, and formatting tools
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            -- "mfussenegger/nvim-dap",
            -- "mfussenegger/nvim-lint",
            "mhartington/formatter.nvim", -- Provides :Format[Write][Lock] commands, which can be used in Buf events or bound to <leader> keys. Does no formatting while typing; use LSP services for that. TODO: compare to stevearc/conform.nvim

            -- "echasnovski/mini.nvim"  -- The Tim Pope of Lua, and then some!
            -- "simrat39/rust-tools.nvim", -- Tools for better development in rust using neovim's builtin lsp
            -- "nvim-neo-tree/neo-tree.nvim"
            -- "nvim-tree/nvim-tree.lua",
            -- "nvim-lualine/lualine.nvim",
            -- "kyazdani42/nvim-web-devicons",
            -- { "glepnir/lspsaga.nvim", branch = "main" } -- See the following for keybindings: https://youtu.be/vdn_pKJUda8?si=VXnW4xurpH3O4Tcy&t=3106
            -- "windwp/nvim-autopairs",
            -- "lewis6991/gitsigns.nvim",
        },

        -- Move the lazy-lock file from my vim directory to the share directory
        -- so that I don't have to deal with version controlling it in git.
        -- Some people may want to do that, but I don't think it's for me.

        lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json",

        ui = {
            icons = {
                loaded = "•",
                not_loaded = "o",
                task = "√ ",
                list = { "•", ">", "*", "-" },
            },
        },
    })
end

--
-- Setup Telescope, then install a bunch of keybindings to help invoke it.
--
local function init_telescope()
    require("telescope").setup()

    local utils = require("utils")

    -- Search for and in files

    utils.set_keymap_normal("<leader>tlg", ":Telescope live_grep<CR>") -- Search open buffers
    utils.set_keymap_normal("<leader>tgs", ":Telescope grep_string<CR>") -- Search directory for hot string
    utils.set_keymap_normal("<leader>tff", ":Telescope find_files<CR>") -- Search for files
    utils.set_keymap_normal("<leader>tts", ":Telescope treesitter<CR>") -- Show Treesitter query results
    utils.set_keymap_normal("<leader>tfz", ":Telescope current_buffer_fuzzy_find<CR>") -- Like it says

    -- CTags

    utils.set_keymap_normal("<leader>ttg", ":Telescope tags<CR>") -- <CTags support>
    utils.set_keymap_normal("<leader>tbtg", ":Telescope current_buffer_tags<CR>") -- <CTags support>

    -- Git

    utils.set_keymap_normal("<leader>tgf", ":Telescope git_files<CR>") -- Show files tracked by git
    utils.set_keymap_normal("<leader>tgc", ":Telescope git_commits<CR>") -- Show git commits
    utils.set_keymap_normal("<leader>tbgc", ":Telescope git_bcommits<CR>") -- Show git commits for current buffer
    utils.set_keymap_normal("<leader>tgb", ":Telescope git_branches<CR>") -- Show git branches
    utils.set_keymap_normal("<leader>tgs", ":Telescope git_status<CR>") -- Show git status
    utils.set_keymap_normal("<leader>tgh", ":Telescope git_stash<CR>") -- Show git stash

    -- Telescope

    utils.set_keymap_normal("<leader>tpp", ":Telescope git_builtin<CR>") -- Show pickers
    utils.set_keymap_normal("<leader>trr", ":Telescope git_resume<CR>") -- Resume last picker
    -- pickers
    -- planets
    -- symbols

    -- Neovim

    -- commands
    -- quickfix
    -- quickfixhistory
    -- loclist
    -- oldfiles
    -- command_history
    -- search_history
    -- vim_options
    -- help_tags
    -- man_pages
    -- reloader
    -- buffers
    -- colorscheme
    -- marks
    -- registers
    utils.set_keymap_normal("<leader>tkm", ":Telescope keymaps<CR>") -- Show key mappings
    -- filetypes
    -- highlights
    -- autocommands
    -- spell_suggest
    -- tagstack
    -- jumplist

    -- LSP

    -- lsp_references
    -- lsp_incoming_calls
    -- lsp_outgoing_calls
    -- lsp_definitions
    -- lsp_type_definitions
    -- lsp_implementations
    -- lsp_document_symbols
    -- lsp_workspace_symbols
    -- lsp_dynamic_workspace_symbols

    -- ???

    -- diagnostics
end

--
-- Setup Treesitter to automatically pull in on-demand any parsers that are needed.
-- Use the parers for indenting and highlighting.
--
local function init_treesitter()
    require("nvim-treesitter.configs").setup({
        auto_install = true,
        indent = { enable = true },
        highlight = { enable = true },
    })
end

local function init_cmp()
    local cmp = require("cmp")

    -- Suggested by nvim-cmp

    vim.opt.completeopt = { "menu", "menuone", "noselect" }

    -- To find out about options, see:
    --
    --      https://github.com/hrsh7th/nvim-cmp/blob/main/doc/cmp.txt
    --      (search for *cmp-config*)
    --
    -- Or run :help cmp-config

    local select_opts = { behavior = cmp.SelectBehavior.Select }

    local opts = {

        mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),

            ["<LEFT>"] = cmp.mapping.select_prev_item(),
            ["<RIGHT>"] = cmp.mapping.select_next_item(),
            -- These are part of the presets
            -- ["<UP>"] = cmp.mapping.select_prev_item(),
            -- ["<DOWN>"] = cmp.mapping.select_next_item(),

            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<C-SPACE>"] = cmp.mapping.complete(),
            -- ["<ESC>"] = cmp.mapping.close(),
            ["<ESC>"] = cmp.mapping.abort(),

            ["<Tab>"] = cmp.mapping(function(fallback)
                local col = vim.fn.col(".") - 1
                if cmp.visible() then
                    cmp.select_next_item(select_opts)
                elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
                    fallback()
                else
                    cmp.complete()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item(select_opts)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),

        sources = {
            { name = "buffer", keyword_length = 3 },
            { name = "cmdline" },
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "path" },
        },
    }

    cmp.setup(opts)
end

local function init_mason()
    require("mason").setup({
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "-",
            },
        },
    })
end

-- Use Mason-lspconfig to install the LSP plugins
--
-- Fun fact: I was wondering why there was a 'handlers' field here to
-- initialize the plugins when there was a perfectly fine mechanism for doing
-- this in nvim-lspconfig. It turns out that the versions here are invoked
-- after any plugins are downloaded and installed. If we were to put this
-- configuration process in the nvim-lspconfig setup() function, it would be
-- possible for that package to try to initialize the plugins before
-- mason-lsp-config had finished loading them.
local function init_mason_lspconfig()
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
            "clangd", -- understands your C++ code and adds smart features to your editor: code completion, compile errors, go-to-definition and more (https://clangd.llvm.org)
            "lua_ls", -- A language server that offers Lua language support - programmed in Lua (https://github.com/LuaLS/lua-language-server)
            -- This is putting up some errors when I try to use it. And it's slow to build/install.
            -- "pylyzer", -- A fast static code analyzer & language server for Python (https://github.com/mtshiba/pylyzer)
            "pylsp", -- Fork of the python-language-server project, maintained by the Spyder IDE team and the community (https://github.com/python-lsp/python-lsp-server)
            "ruff_lsp", -- A Language Server Protocol implementation for Ruff - An extremely fast Python linter, written in Rust (https://github.com/astral-sh/ruff-lsp/)
            "rust_analyzer", -- rust-analyzer is an implementation of the Language Server Protocol for the Rust programming language. It provides features like completion and goto definition for many code editors, including VS Code, Emacs and Vim (https://github.com/rust-lang/rust-analyzer)
            -- This is putting up some errors when I try to use it.
            -- "sourcery", -- Sourcery is a tool available in your IDE, GitHub, or as a CLI that suggests refactoring improvements to help make your code more readable and generally higher quality (https://docs.sourcery.ai/)
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
            -- Looks like pylsp automatically installs the following support
            -- tools. This means that we don't need to duplicate them elsewhere
            -- (like when configuring formatter.nvim).
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
end

-- Use mason-tool-installer to download the non-LSP (formatting, linting) plugins
--
-- These are installed on VimEnter (that is, just after vim finishes starting up).
local function init_mason_tool_installer()
    require("mason-tool-installer").setup({
        ensure_installed = {
            -- lua
            "stylua",

            -- python
            "autoflake", -- Removes unused imports and unused variables as reported by pyflakes
            "isort",
            "ruff",

            -- Loading rustfmt is deprecated. The :Mason dialog tells us to use
            -- rustup (that is, the version that comes standard with rust)
            -- instead.

            -- rust
            -- "rustfmt",

            -- sh
            "beautysh",
        },
    })
end

-- Use formatter.nvim to configure the formatting plugins
--
-- Formatting is done in response to :Format[Write][Lock] commands. We extend
-- this by adding a BufWritePost handler to invoke FormatWrite. This approach
-- is recommended by the formatting.nvim docs. It's not apparent to me why the
-- documentation recommends this approach rather than calling Format on a
-- BufWritePre hook.
local function init_formatter()
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
end

-- local rusttools_status_ok, rusttools = pcall(require, "rust-tools")
-- if not rusttools_status_ok then
--     return
-- end
--
-- local do_map = function(keys, fn)
--     vim.keymap.set("n", "<leader>" .. keys, fn, { noremap = true, silent = true, buffer = bufnr })
-- end
--
-- -- See https://www.youtube.com/watch?v=gihHLsClHF0 at around 3:50 for hints on configuration
--
-- rusttools.setup({
--     server = {
--         cmd = { "rustup", "run", "stable", "rust-analyzer" },
--         on_attach = function(_, bufnr)
--             do_map("gc", rusttools.open_cargo_toml.open_cargo_toml)
--             do_map("gd", vim.lsp.buf.definition)
--             do_map("gi", vim.lsp.buf.implementation)
--             do_map("gt", vim.lsp.buf.type_definition)
--             do_map("sr", vim.lsp.buf.references)
--             -- do_map("sh", vim.lsp.buf.signature_help)
--             do_map("K", vim.lsp.buf.hover)
--             do_map("rn", vim.lsp.buf.rename)
--             do_map("ff", vim.lsp.buf.formatting)
--             do_map("ca", vim.lsp.buf.code_action) -- Use rust-tools's?
--         end,
--     },
--     tools = {
--         inlay_hints = {
--             highlight = "DiagnosticHint",
--         },
--     },
-- })

init_lazy()
init_telescope()
init_treesitter()
init_cmp()
init_mason()
init_mason_lspconfig()
init_mason_tool_installer()
init_formatter()
