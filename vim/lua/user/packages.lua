-- Prefix the given partial path with "https://github.com/" so that we don't
-- need to always spell out the whole thing in our pack specs.
local gh = function(x) return 'https://github.com/' .. x end

-- Return the package's name, using the 'name' field if it exists, or extracting
-- it from the 'src' field otherwise.
local pack_name = function(pack)
    return pack.name and pack.name or string.match(pack.src, ".*/(.*)%..*")
end

-- Configure a package. If it has a config function, call it. If not but it has
-- opts, pass it as a parameter to the package's setup function.
local configure_pack = function(pack)
    if pack.config ~= nil then
        pack.config()
    elseif pack.opts ~= nil then
        require(pack_name(pack)).setup(pack.opts)
    end
end

-- List all of the packages we want to install. The information for each
-- package is a superset of the format vim.pack.add() wants. That format is
-- extended by including optional 'disabled', 'config', and 'opts' fields.
--
-- We process this list a little bit first to remove all disabled packages.
local packs = vim.iter({
        -- ---------------------------------------------------------------------
        -- blink.cmp
        -- Performant, batteries-included completion plugin for Neovim
        --
        -- Has mini.nvim equivalent.
        {
            -- I seem to have a little problem with this plugin, so I'm
            -- disabling it for now. It either has its own problem, or is
            -- conflicting with something else, such as copilot. Regardless,
            -- what happens is that, when I start typing, the completion popup
            -- appears, but as soon as I type the next character, the insertion
            -- point moves in front of the first character I typed, causing what
            -- I type to get jumbled up. Enabled vim.opt.autocomplete (for
            -- buffer-related completion) and added the sample code from ':help
            -- lsp-lint' (for LSP-related completion) instead. See events.lua.

            disabled = true,
            src = gh("saghen/blink.cmp"),
            version = vim.version.range("1.*"),
            opts = {
                keymap = {
                    preset = "default",
                    ["<CR>"] = { "accept", "fallback" }, -- alias for <C-y>
                }
            },
        },
        -- ---------------------------------------------------------------------
        -- catppuccin
        -- Soothing pastel theme for Neovim
        {
            disabled = true, -- Now built into nvim
            src = gh("catppuccin/nvim"),
            name = "catppuccin",
            config = function()
                -- See `:help catppuccin-configuration` for all configuration
                -- options.
                require("catppuccin").setup({
                    transparent_background = true,
                    term_colors = true,
                })
                vim.cmd.colorscheme("catppuccin")
            end
        },
        -- ---------------------------------------------------------------------
        -- conform.nvim
        -- Lightweight yet powerful formatter plugin for Neovim
        {
            src = gh("stevearc/conform.nvim"),
            opts = {
                default_format_opts = {
                    -- Normally let the LSPs do the formatting.
                    lsp_format = "fallback",
                },
                formatters_by_ft = {
                    -- For Python, use ruff, and then isort.
                    python = { "ruff", "isort" },
                },
                format_on_save = {},
            },
        },
        -- ---------------------------------------------------------------------
        -- copilot.vim
        -- Neovim plugin for GitHub Copilot
        --
        -- Do I need this? Can I use the steps in *lsp-copilot*?
        {
            disabled = false, -- Disabled because it conflicts with autocomplete
            src = gh("github/copilot.vim"),
            config = function()
                kr.set_copilot_mapping()
            end
        },
        -- ---------------------------------------------------------------------
        -- copilot.lua
        --
        -- Disabled until I have time to vet it
        {
            disabled = true,
            src = gh("zbirenbaum/copilot.lua"),
            config = function()
                kr.set_copilot_mapping()

                require("copilot").setup({
                    panel = {
                        enabled = false,
                    },
                    suggestion = {
                        auto_trigger = true,
                        hide_during_completion = false,
                        keymap = {
                            accept = "<C-y>",
                            next = "<C-]>",
                            prev = "<C-[>",
                            dismiss = "<C-\\>",
                        },
                    },
                })
            end,
        },
        -- ---------------------------------------------------------------------
        -- Three packages for supporting fzf. I'll play with these until I
        -- determine which one I like best (if any).
        -- ---------------------------------------------------------------------
        -- fzf.vim
        -- fzf ❤️ vim
        --
        -- NB: Make sure it can access the fzf binary that I installed with
        -- homebrew.
        {
            disabled = true,
            src = gh("junegunn/fzf.vim"),
            config = function()
                vim.keymap.set("n", "<leader>ff", ":Files<CR>")
                vim.keymap.set("n", "<leader>fg", ":Rg<CR>")
                vim.keymap.set("n", "<leader>fb", ":Buffers<CR>")
                -- Lots of other commands. See:
                --
                --      https://github.com/junegunn/fzf.vim
            end,
        },
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
        -- telescope-fzf-native.nvim
        {
            disabled = true, -- Need mechanism for making binary component
            src = gh("nvim-telescope/telescope-fzf-native.nvim"),
            build = "make",
        },
        -- ---------------------------------------------------------------------
        -- indent-blankline.nvim
        -- Indent guides for Neovim
        --
        -- Has mini.nvim similarities.
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
        --
        -- Has mini.nvim equivalent.
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
                    lualine_x = { { "datetime", style = "%F %T" } },
                    lualine_y = { "lsp_status", "filetype" },
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
        -- nvim-treesitter-textobjects
        -- Syntax aware text-objects, select, move, swap, and peek support
        {
            -- NOTE: None of this actually works any more with the new
            -- nvim-treesitter@main, so I've disabled it for now. See the new
            -- instructions for nvim-treesitter-textobjects@main. See also:
            -- https://www.youtube.com/watch?v=vZtL_Er4QpQ

            disabled = true,
            src = gh("nvim-treesitter/nvim-treesitter-textobjects"),
            config = function()
                require("nvim-treesitter").setup({
                    textobjects = {
                        select = {
                            enable = true,
                            lookahead = true,
                            keymaps = {
                                ["af"] = { query = "@function.outer", desc = "Select outer part of a function region" },
                                ["if"] = { query = "@function.inner", desc = "Select inner part of a function region" },
                                ["ac"] = { query = "@comment.outer", desc = "Select outer part of a comment region" },
                                ["ic"] = { query = "@comment.inner", desc = "Select inner part of a comment region" },
                            },
                        },
                        swap = {
                            enable = true,
                            swap_next = {
                                ["<leader>sa"] = { query = "@parameter.inner", desc = "Swap with next parameter" },
                            },
                            swap_previous = {
                                ["<leader>sA"] = { query = "@parameter.inner", desc = "Swap with previous parameter" },
                            },
                        },
                        move = {
                            enable = false,
                        },
                        lsp_interop = {
                            enable = false,
                        },
                    },
                })
            end
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
        -- telescope.nvim
        -- Find, Filter, Preview, Pick. All lua, all the time
        --
        -- Has mini.nvim equivalents (pick, files, extra).
        {
            disabled = true, -- Disable until we have plenary and ripgrep installed, too
            src = gh("nvim-telescope/telescope.nvim"),
            dependencies = {
                "nvim-lua/plenary.nvim",
                "BurntSushi/ripgrep",
            },
            config = function()
                require("telescope").setup({
                    defaults = {
                        path_display = { "filename_first" },
                        file_ignore_patterns = { "__pycache__/" },
                    },
                })

                kr.set_telescope_mapping()
            end,
        },
        -- ---------------------------------------------------------------------
        -- trouble.nvim
        -- A pretty diagnostics, references, telescope results, quickfix and
        -- location list to help you solve all the trouble your code is causing
        {
            src = gh("folke/trouble.nvim"),
            config = function()
                require("trouble").setup({})
                kr.set_trouble_mapping()
            end
        },
        -- ---------------------------------------------------------------------
        -- which-key.nvim
        -- Create key bindings that stick. WhichKey helps you remember your
        -- Neovim keymaps, by showing available keybindings in a popup as you
        -- type.
        --
        -- Perhaps mini.vim.clue?
        {
            src = gh("folke/which-key.nvim"),
            opts = {
                delay = 400,
                win = {
                    border = "double",
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


-- See what can be done in an update-results page:
--
--      https://youtu.be/J1r0vrqOMJo?si=u2VZ9hJlZzFmTOGS&t=419
--
-- vim.pack.update(nil, { force = false })
-- vim.print(vim.pack.get())
-- vim.print(require('lualine').get_config())

--
--
