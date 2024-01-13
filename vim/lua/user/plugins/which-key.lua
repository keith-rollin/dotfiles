return {
    "folke/which-key.nvim",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {
        plugins = {
            marks = false,
            registers = false,
            spelling = { enabled = false, },
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

        StripWhitespace = function()
            -- Originally from some old vim.org tip that I can't find any more.
            -- Modified with trim_trailing_whitespace handler in
            -- editor/lua/editorconfig.lua
            local oldquery = vim.fn.getreg('/')
            local view = vim.fn.winsaveview()
            vim.cmd("silent keepjumps keeppatterns %s/\\s\\+$//e")
            vim.fn.winrestview(view)
            vim.fn.setreg('/', oldquery)
        end

        local n_mode = { mode = "n", prefix = "" }
        local v_mode = { mode = "v", prefix = "" }
        local x_mode = { mode = "x", prefix = "" }

        wk.register({
            [","] = { "<cmd>FSHere<CR>", "Switch to paired file" },
            ["."] = { "<c-^>", "Edit alternate file" },
            [" "] = { "<cmd>lua StripWhitespace()<CR>", "Strip trailing white space" },
            d = {
                name = "Diagnostics" -- defined in lsp.lua ("vim.diagnostics"},
            },
            e = {
                name = "Edit",
                g = { "<cmd>edit ~/.gitconfig<CR>", ".gitconfig" },
                v = { "<cmd>edit " .. vim.env.MYVIMRC .. "<CR>", ".init.lua" },
                z = { "<cmd>edit ~/.zshrc<CR>", ".zshrc" },
            },
            h = { "<cmd>nohlsearch<CR>", "Disable highlight" },
            l = {
                name = "LSP" -- defined in lsp.lua ("vim.lsp"},
            },
            n = { "<cmd>20Lex<CR>", "Show directory tree" },
            -- r defined in lsp.lua (rename},
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
                name = "TreeSitter",
            },
            w = { "<cmd>w<CR>", "Write current file" },

        }, {
            prefix = "<leader>",
        })

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

            -- Remap commands to keep the found text centered. Use 'zv' to open
            -- folds in case the selected text is hidden.

            n = { "nzzzv", "Find next and re-center" },
            N = { "Nzzzv", "Find previous and re-center" },
            ["*"] = { "*zzzv", "Find next word under cursor and re-center" },
            ["#"] = { "#zzzv", "Find previous word under cursor and re-center" },
            -- ["g*"] = { "g*zzzv" },
            -- ["g#"] = { "g#zzzv" },
            -- ["<C-D>"] = { "<C-D>zz" },
            -- ["<C-U>"] = { "<C-U>zz" },

            -- Tab / Shift-Tab to change buffers.

            ["<Tab>"] = { "<cmd>bnext<CR>", "Next buffer" },
            ["<S-Tab>"] = { "<cmd>bprevious<CR>", "Previous buffer" },
            ["<M-Tab>"] = { "<c-^>", "Edit alternate file" },
        }
        wk.register(n_mappings, n_mode)

        local v_mappings = {
            -- Take the selection and move it up or down, after which, reselect
            -- the text, reformat/indent it, and select it again.

            J = { "<cmd>m '>+1<CR>gv=gv" },
            K = { "<cmd>m '<-2<CR>gv=gv" },

            ["<"] = { "<gv", "Stay in visual mode when indenting" },
            [">"] = { ">gv", "Stay in visual mode when indenting" },
        }
        wk.register(v_mappings, v_mode)

        local nx_mappings = {
            H = { "^", "Alias for ^" },
            L = { "g_", "Alias for g_" },
        }
        wk.register(nx_mappings, n_mode)
        wk.register(nx_mappings, x_mode)
    end,
}
