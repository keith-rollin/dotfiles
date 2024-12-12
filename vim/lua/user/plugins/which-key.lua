return {
    "folke/which-key.nvim",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 1000
    end,
    config = function()
        local wk = require("which-key")
        kr.extend({
            mapping = {
                set = function(mapping)
                    wk.add(mapping)
                end,
            },
        })

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

        wk.setup({
            delay = function()
                return 400
            end,
            plugins = {
                marks = false,
                registers = false,
                spelling = { enabled = false },
            },
            win = {
                border = "double",
            },
        })

        kr.mapping.set({
            { "<leader> ",  "<cmd>lua StripWhitespace()<CR>",          desc = "Strip trailing white space" },
            { "<leader>,",  "<cmd>FSHere<CR>",                         desc = "Switch to paired file" },
            { "<leader>.",  "<c-^>",                                   desc = "Edit alternate file" },
            { "<leader>D",  group = "Debug" }, -- defined in dap.lua
            { "<leader>S",  group = "Split Management" },
            { "<leader>Sh", "<cmd>split<CR>",                          desc = "Split horizontally" },
            { "<leader>Sv", "<cmd>vsplit<CR>",                         desc = "Split vertically" },
            { "<leader>Sx", "<cmd>close<CR>",                          desc = "Close split" },
            { "<leader>d",  group = "Diagnostics" }, -- defined in lsp.lua ("vim.diagnostics"},
            { "<leader>e",  group = "Edit" },
            { "<leader>eg", "<cmd>edit ~/.gitconfig<CR>",              desc = ".gitconfig" },
            { "<leader>ev", "<cmd>edit " .. vim.env.MYVIMRC .. "<CR>", desc = "init.lua" },
            { "<leader>ez", "<cmd>edit ~/.zshrc<CR>",                  desc = ".zshrc" },
            { "<leader>i",  group = "Info" },
            { "<leader>iz", "<cmd>Lazy<CR>",                           desc = "Lazy" },
            { "<leader>l",  group = "LSP" },
            { "<leader>ll", "<cmd>nohlsearch<CR>",                     desc = "Disable highlight" },
            { "<leader>n",  group = "netrw" },
            { "<leader>nf", "<cmd>20Lex %:p:h<CR>",                    desc = "Show directory of current file" },
            { "<leader>nn", "<cmd>20Lex<CR>",                          desc = "Show current working directory" },
            -- n = { "<cmd>20Lex<CR>", "Show directory tree" },
            -- r defined in lsp.lua (rename),
            { "<leader>s",  group = "Toggle Settings" },
            { "<leader>si", "<cmd>set cursorline!<CR>",                desc = "Toggle 'cursorline'" },
            { "<leader>sl", "<cmd>set list!<CR>",                      desc = "Toggle 'list'" },
            { "<leader>ss", "<cmd>set spell!<CR>",                     desc = "Toggle 'spell'" },
            { "<leader>sw", "<cmd>set wrap!<CR>",                      desc = "Toggle line wrapping" },
            { "<leader>t",  group = "Telescope" }, -- defined in telescope.lua
            { "<leader>w",  "<cmd>w<CR>",                              desc = "Write current file" },
        })

        kr.mapping.set({
            { "<C-H>",   desc = "<C-W><C-H>" },
            { "<C-J>",   desc = "<C-W><C-J>" },
            { "<C-K>",   desc = "<C-W><C-K>" },
            { "<C-L>",   desc = "<C-W><C-L>" },

            -- Tab / Shift-Tab to change buffers.

            { "<M-Tab>", "<c-^>",                 desc = "Edit alternate file" },
            { "<S-Tab>", "<cmd>bprevious<CR>",    desc = "Previous buffer" },
            { "<Tab>",   "<cmd>bnext<CR>",        desc = "Next buffer" },

            -- Change ZZ to not winge about not having visited every buffer.

            { "ZZ",      "<cmd>xa<cr>",           desc = "Quit without whining" },

            -- Remap gf to open the file under the cursor even if it doesn't
            -- exist. This tip is from the help for 'gf'. However, that help
            -- says to just use the 'map' command. I'm not sure if that's the
            -- best way to go, so I'm using nnoremap.

            { "gf",      "<cmd>edit <cfile><cr>", desc = "Edit file under cursor" },

        })

        kr.mapping.set({
            {
                mode = { "v" },

                { "<", "<gv",                 desc = "Stay in visual mode when indenting" },
                { ">", ">gv",                 desc = "Stay in visual mode when indenting" },

                -- Take the selection and move it up or down, after which, reselect
                -- the text, reformat/indent it, and select it again.

                { "J", "<cmd>m '>+1<CR>gv=gv" },
                { "K", "<cmd>m '<-2<CR>gv=gv" },
            }
        })

        kr.mapping.set({
            { "H", "^",  desc = "Alias for ^",  mode = "n" },
            { "H", "^",  desc = "Alias for ^",  mode = "x" },
            { "L", "g_", desc = "Alias for g_", mode = "n" },
            { "L", "g_", desc = "Alias for g_", mode = "x" },
        })
    end,
}
