return {
    "folke/which-key.nvim",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 1000
    end,
    opts = {
        plugins = {
            marks = false,
            registers = false,
            spelling = { enabled = false },
        },
        key_labels = {
            ["<space>"] = "SPC",
            ["<cr>"] = "RET",
            ["<tab>"] = "TAB",
        },
        window = {
            border = "double",
        },
    },
    config = function()
        local wk = require("which-key")
        _G.kr = {
            mapping = {
                set = function(mapping, opts) wk.register(mapping, opts) end,
                set_normal = function(mapping, opts)
                    local n_mode = vim.tbl_extend("error", { mode = "n" }, opts or {})
                    kr.mapping.set(mapping, n_mode)
                end,
                set_visual = function(mapping, opts)
                    local v_mode = vim.tbl_extend("error", { mode = "v" }, opts or {})
                    kr.mapping.set(mapping, v_mode)
                end,
                set_visual_select = function(mapping, opts)
                    local x_mode = vim.tbl_extend("error", { mode = "x" }, opts or {})
                    kr.mapping.set(mapping, x_mode)
                end,
            },
        }

        StripWhitespace = function()
            -- Originally from some old vim.org tip that I can't find any more.
            -- Modified with trim_trailing_whitespace handler in
            -- runtime/editor/lua/editorconfig.lua
            local oldquery = vim.fn.getreg("/")
            local view = vim.fn.winsaveview()
            vim.cmd("silent keepjumps keeppatterns %s/\\s\\+$//e")
            vim.fn.winrestview(view)
            vim.fn.setreg("/", oldquery)
        end

        kr.mapping.set_normal({
            [","] = { "<cmd>FSHere<CR>", "Switch to paired file" },
            ["."] = { "<c-^>", "Edit alternate file" },
            [" "] = { "<cmd>lua StripWhitespace()<CR>", "Strip trailing white space" },
            D = {
                name = "Debug", -- defined in dap.lua
            },
            d = {
                name = "Diagnostics", -- defined in lsp.lua ("vim.diagnostics"},
            },
            e = {
                name = "Edit",
                g = { "<cmd>edit ~/.gitconfig<CR>", ".gitconfig" },
                v = { "<cmd>edit " .. vim.env.MYVIMRC .. "<CR>", ".init.lua" },
                z = { "<cmd>edit ~/.zshrc<CR>", ".zshrc" },
            },
            i = {
                name = "Info",
                l = { "<cmd>LspInfo<CR>", "LSP" },
                m = { "<cmd>Mason<CR>", "Mason" },
                z = { "<cmd>Lazy<CR>", "Lazy" },
            },
            l = {
                name = "LSP", -- defined in lsp.lua ("vim.lsp"},
                l = { "<cmd>nohlsearch<CR>", "Disable highlight" },
            },
            n = { "<cmd>20Lex<CR>", "Show directory tree" },
            -- r defined in lsp.lua (rename),
            s = {
                name = "Toggle settings",
                i = { "<cmd>set cursorline!<CR>", "Toggle 'cursorline'" },
                l = { "<cmd>set list!<CR>", "Toggle 'list'" },
                s = { "<cmd>set spell!<CR>", "Toggle 'spell'" },
                w = { "<cmd>set wrap!<CR>", "Toggle line wrapping" },
            },
            S = {
                name = "Split management",
                h = { "<cmd>split<CR>", "Create horizontal split" },
                v = { "<cmd>vsplit<CR>", "Create vertical split" },
                x = { "<cmd>close<CR>", "Close split" },
            },
            t = {
                name = "Telescope", -- defined in telescope.lua
            },
            w = { "<cmd>w<CR>", "Write current file" },
        }, { prefix = "<leader>" })

        local n_mappings = {
            ["<C-J>"] = { "<C-W><C-J>" },
            ["<C-K>"] = { "<C-W><C-K>" },
            ["<C-L>"] = { "<C-W><C-L>" },
            ["<C-H>"] = { "<C-W><C-H>" },

            -- Remap gf to open the file under the cursor even if it doesn't
            -- exist. This tip is from the help for 'gf'. However, that help
            -- says to just use the 'map' command. I'm not sure if that's the
            -- best way to go, so I'm using nnoremap.

            ["gf"] = { "<cmd>edit <cfile><cr>", "Edit file under cursor" },

            -- Tab / Shift-Tab to change buffers.

            ["<Tab>"] = { "<cmd>bnext<CR>", "Next buffer" },
            ["<S-Tab>"] = { "<cmd>bprevious<CR>", "Previous buffer" },
            ["<M-Tab>"] = { "<c-^>", "Edit alternate file" },
        }
        kr.mapping.set_normal(n_mappings)

        local v_mappings = {
            -- Take the selection and move it up or down, after which, reselect
            -- the text, reformat/indent it, and select it again.

            J = { "<cmd>m '>+1<CR>gv=gv" },
            K = { "<cmd>m '<-2<CR>gv=gv" },

            ["<"] = { "<gv", "Stay in visual mode when indenting" },
            [">"] = { ">gv", "Stay in visual mode when indenting" },
        }
        kr.mapping.set_visual(v_mappings)

        local nx_mappings = {
            H = { "^", "Alias for ^" },
            L = { "g_", "Alias for g_" },
        }
        kr.mapping.set_normal(nx_mappings)
        kr.mapping.set_visual_select(nx_mappings)
    end,
}
