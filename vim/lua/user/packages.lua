-- Some additional packages that I want to install.
--
-- A minimalist Lua buffer evaluator that executes the current editor buffer
-- https://github.com/FractalCodeRicardo/lua-inspector
--
-- A handy scratch pad / REPL / debug console for Lua development and Neovim
-- exploration
-- https://github.com/YaroSpace/lua-console.nvim
--
-- Library of 45+ independent Lua modules improving Neovim experience with
-- minimal effort
-- https://github.com/nvim-mini/mini.nvim
--
-- Neovim file explorer: edit your filesystem like a buffer
-- https://github.com/stevearc/oil.nvim
--
-- Notes on configuring mini.files:
-- https://www.reddit.com/r/neovim/comments/1bceiw2/oilnvim_vs_minifiles

--
-- Prefix the given partial path with "https://github.com/" so that we don't
-- need to always spell out the whole thing in our pack specs.
--
local gh = function(x) return 'https://github.com/' .. x end

--
-- Return the package's name, using the 'name' field if it exists, or extracting
-- it from the 'src' field otherwise.
--
local pack_name = function(pack)
    return pack.name and pack.name or string.match(pack.src, ".*/(.*)%..*")
end

--
-- Configure a package. If it has a config function, call it. If not but it has
-- opts, pass it as a parameter to the package's setup function.
--
local configure_pack = function(pack)
    if pack.config ~= nil then
        pack.config()
    elseif pack.opts ~= nil then
        require(pack_name(pack)).setup(pack.opts)
    end
end

--
-- List all of the packages we want to install. The information for each
-- package is a superset of the format vim.pack.add() wants. That format is
-- extended by including optional 'disabled', 'config', and 'opts' fields.
--
-- We process this list a little bit first to remove all disabled packages.
--
local packs = vim.iter({
        -- ---------------------------------------------------------------------
        -- conform.nvim
        -- Lightweight yet powerful formatter plugin for Neovim
        --
        -- We could also "simply" try:
        --
        --    https://github.com/smnatale/nvim_native/blob/main/lua/formatting.lua
        --    https://github.com/mplusp/nvim-0.12-built-in-inline-completion/blob/main/lua/core/lsp.lua
        {
            src = gh("stevearc/conform.nvim"),
            opts = {
                default_format_opts = {
                    -- Normally let the LSPs do the formatting.
                    lsp_format = "fallback",
                },
                formatters_by_ft = {
                    python = { "ruff_organize_imports", lsp_format = "first" },
                },
                format_on_save = {},
            },
        },
        -- ---------------------------------------------------------------------
        -- copilot.vim
        -- Neovim plugin for GitHub Copilot
        --
        -- Do I need this? Can I use the steps in *lsp-copilot*? Should I use
        -- copilot.lua instead?
        {
            src = gh("github/copilot.vim"),
            config = function()
                kr.set_copilot_mapping()
            end
        },
        -- ---------------------------------------------------------------------
        -- fzf.lua
        -- Improved fzf.vim written in lua
        --
        -- Needs nvim-web-devicons, installed later.
        -- Can also make use of fd, rg, etc. See:
        --
        --      https://github.com/ibhagwan/fzf-lua
        --
        -- This package has TONs of commands. See above web page.
        {
            src = gh("ibhagwan/fzf-lua"),
            config = function()
                local fzf_lua = require("fzf-lua")
                fzf_lua.setup({ "default" })
                vim.keymap.set("n", "<leader>ff", fzf_lua.files)
                vim.keymap.set("n", "<leader>fg", fzf_lua.live_grep)
                vim.keymap.set("n", "<leader>fb", fzf_lua.buffers)
            end,
        },
        -- ---------------------------------------------------------------------
        -- indent-blankline.nvim
        -- Indent guides for Neovim
        {
            src = gh("lukas-reineke/indent-blankline.nvim"),
            name = "ibl",
            opts = {
                indent = {
                    char = "┊",
                    highlight = { "DiagnosticHint" },
                },
                scope = {
                    enabled = false,
                },
            },
        },
        -- ---------------------------------------------------------------------
        -- lualine.nvim
        -- A blazing fast and easy to configure neovim statusline plugin written
        -- in pure lua
        {
            -- I don't feel compelled to use a custom statusline. However, I've
            -- installed lualine for two reasons:
            --
            -- * The terminal and vim theme I'm using (catppuccin) seems to
            --   result in a status line that doesn't have a background color.
            --   This makes it hard to read. lualine makes it easy to install a
            --   theme that makes the status line readable.
            -- * lualine has a datetime component that shows the
            --   continually-updated time.

            src = gh("nvim-lualine/lualine.nvim"),
            opts = {
                options = {
                    theme = "gruvbox_dark", -- Change from "auto"
                    component_separators = '',
                    section_separators = { left = '', right = '' },
                    always_show_tabline = false,
                    globalstatus = true,
                },
                -- Default section settings:
                -- sections = {
                --     lualine_a = { "mode" },
                --     lualine_b = { "branch", "diff", "diagnostics" },
                --     lualine_c = { "filename" },
                --     lualine_x = { "encoding", "fileformat", "filetype" },
                --     lualine_y = { "progress" },
                --     lualine_z = { "location" }
                -- },
                sections = {
                    lualine_b = { "diff", "diagnostics" },
                    lualine_x = { { "datetime", style = "%F %T" } },
                    lualine_y = { "filetype" },
                    lualine_z = { "progress", {
                        function()
                            local col = vim.fn.charcol('.')
                            local line = vim.fn.line('.')
                            local lines = vim.fn.line('$')
                            return string.format('%d | %d | %d', col, line, lines)
                        end
                    } },
                },
            },
        },
        -- ---------------------------------------------------------------------
        -- nvim-lspconfig
        -- Quickstart configs for Nvim LSP
        {
            src = gh("neovim/nvim-lspconfig"),
        },
        -- ---------------------------------------------------------------------
        -- nvim-treesitter
        -- Nvim Treesitter configurations and abstraction layer
        {
            src = gh("nvim-treesitter/nvim-treesitter"),
            config = function()
                -- These are built-into Neovim, so we don't need to install them.
                -- - ✅ OK Parser: c                ABI: 15, path: /opt/homebrew/Cellar/neovim/0.12.5_1/lib/nvim/parser/c.so
                -- - ✅ OK Parser: lua              ABI: 15, path: /opt/homebrew/Cellar/neovim/0.12.5_1/lib/nvim/parser/lua.so
                -- - ✅ OK Parser: markdown         ABI: 15, path: /opt/homebrew/Cellar/neovim/0.12.5_1/lib/nvim/parser/markdown.so
                -- - ✅ OK Parser: markdown_inline  ABI: 15, path: /opt/homebrew/Cellar/neovim/0.12.5_1/lib/nvim/parser/markdown_inline.so
                -- - ✅ OK Parser: query            ABI: 15, path: /opt/homebrew/Cellar/neovim/0.12.5_1/lib/nvim/parser/query.so
                -- - ✅ OK Parser: vim              ABI: 15, path: /opt/homebrew/Cellar/neovim/0.12.5_1/lib/nvim/parser/vim.so
                -- - ✅ OK Parser: vimdoc           ABI: 15, path: /opt/homebrew/Cellar/neovim/0.12.5_1/lib/nvim/parser/vimdoc.so

                -- From: https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
                require("nvim-treesitter").install({
                    "bash",
                    "cpp",
                    "diff",
                    "git_config",
                    "git_rebase",
                    "gitattributes",
                    "gitcommit",
                    "gitignore",
                    "go",
                    "html",
                    "javascript",
                    "json",
                    "luadoc",
                    "make",
                    "python",
                    "racket",
                    "regex",
                    "rust",
                    "scheme",
                    "swift",
                    "tsx",
                    "typescript",
                    "zig",
                    "zsh",
                })

                -- Taken from: https://github.com/mplusp/nvim-0.12-vim-pack-intro/blob/main/lua/plugins/nvim-treesitter.lua
                vim.api.nvim_create_autocmd('PackChanged', {
                    desc = 'Handle nvim-treesitter updates',
                    group = vim.api.nvim_create_augroup('nvim-treesitter-pack-changed-update-handler', { clear = true }),
                    callback = function(event)
                        if event.data.kind == 'update' and event.data.spec.name == 'nvim-treesitter' then
                            vim.notify('nvim-treesitter updated, running TSUpdate...', vim.log.levels.INFO)
                            ---@diagnostic disable-next-line: param-type-mismatch
                            local ok = pcall(vim.cmd, 'TSUpdate')
                            if ok then
                                vim.notify('TSUpdate completed successfully!', vim.log.levels.INFO)
                            else
                                vim.notify('TSUpdate command not available yet, skipping', vim.log.levels.WARN)
                            end
                        end
                    end,
                })
            end
        },
        -- ---------------------------------------------------------------------
        -- nvim-web-devicons
        -- Provides Nerd Font icons (glyphs) for use by neovim plugins
        {
            src = gh("nvim-tree/nvim-web-devicons"),
        },
        -- ---------------------------------------------------------------------
        -- which-key.nvim
        -- Create key bindings that stick. WhichKey helps you remember your
        -- Neovim keymaps, by showing available keybindings in a popup as you
        -- type.
        {
            src = gh("folke/which-key.nvim"),
            opts = {
                delay = 400,
                win = {
                    border = "single",
                },
                notify = true,
                expand = 3,
                spec = {
                    { "<leader>S",  group = "Split Management" },
                    { "<leader>c",  group = "Copilot" },
                    { "<leader>d",  group = "Diagnostics" },
                    { "<leader>e",  group = "Edit" },
                    { "<leader>i",  group = "Info" },
                    { "<leader>l",  group = "LSP" },
                    { "<leader>s",  group = "Toggle Settings" },
                    { "<leader>t",  group = "Telescope" },
                    { "<leader>x",  group = "Toggle" },
                    { "<leader>t",  group = "Telescope" },
                    { "<leader>tf", group = "Find Files" },
                    { "<leader>tl", group = "LSP" },
                    { "<leader>tt", group = "Tags" },
                    { "<leader>tg", group = "git" },
                    { "<leader>tp", group = "Pickers" },
                },
            },
        },
    })
    :filter(function(pack)
        return not pack.disabled
    end)
    :totable()

-- Install and configure our packages.

vim.pack.add(packs)
vim.iter(packs):each(configure_pack)



--
--
