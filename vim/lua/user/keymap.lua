-- Custom keys
-- -----------

-- Cheat Sheet (from `:help :map-modes`):
--
-- There are seven sets of mappings:
--
-- - For Normal mode: When typing commands.
-- - For Visual mode: When typing commands while the Visual area is highlighted.
-- - For Select mode: like Visual mode but typing text replaces the selection.
-- - For Operator-pending mode: When an operator is pending (after "d", "y", "c",
--   etc.).
-- - For Insert mode: These are also used in Replace mode.
-- - For Command-line mode: When entering a ":" or "/" command. (KR: And, I
--   suspect, "!" commands.)
-- - For Terminal mode: When typing in a |:terminal| buffer.
--
--      COMMANDS                    MODES
-- :map   :noremap  :unmap     Normal, Visual, Select, Operator-pending
-- :nmap  :nnoremap :nunmap    Normal
-- :vmap  :vnoremap :vunmap    Visual and Select
-- :smap  :snoremap :sunmap    Select
-- :xmap  :xnoremap :xunmap    Visual
-- :omap  :onoremap :ounmap    Operator-pending
-- :map!  :noremap! :unmap!    Insert and Command-line
-- :imap  :inoremap :iunmap    Insert
-- :lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arglistlist
-- :cmap  :cnoremap :cunmap    Command-line
-- :tmap  :tnoremap :tunmap    Terminal
--
-- Use *noremap when recursive mapping is not wanted. Use *unmap to remove a
-- specified binding. Use *mapclear to remove all bindings for that mode.
--
-- Nvim creates the following default mappings (distinct from Vim)
-- See `:help default-mappings`
-- Note that I override <C-L> to move between windows, and so use <Leader>l to
-- remove highlighting instead. See:
--
--  $(brew --cellar)/neovim/<version>/share/nvim/runtime/lua/vim/_editor.lua
--
--      nnoremap Y y$
--      nnoremap <C-L> <Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>
--      inoremap <C-U> <C-G>u<C-U>
--      inoremap <C-W> <C-G>u<C-W>
--      xnoremap * y/\V<C-R>"<CR>
--      xnoremap # y?\V<C-R>"<CR>
--      nnoremap & :&&<CR>

local opts = { noremap = true, silent = true }

local mapn = function(lhs, rhs)
    vim.keymap.set("n", lhs, rhs, opts)
end

local mapnx = function(lhs, rhs)
    vim.keymap.set({ "n", "x" }, lhs, rhs, opts)
end

local mapv = function(lhs, rhs)
    vim.keymap.set("v", lhs, rhs, opts)
end

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

mapn("<leader>.", "<c-^>") -- Edit alternate file
mapn("<leader>,", ":FSHere<CR>")
mapn("<leader> ", ":lua StripWhitespace()<CR>")
-- dn, dl, do, dp defined in lsp.lua ("vim.diagnostics")
mapn("<leader>eg", ":edit ~/.gitconfig<CR>")
mapn("<leader>ev", ":edit " .. vim.env.MYVIMRC .. "<CR>")
mapn("<leader>ez", ":edit ~/.zshrc<CR>")
mapn("<leader>ll", ":nohlsearch<CR>")
-- lc, lD, ld, lf, lh, li, lr, ls, lt defined in lsp.lua ("vim.lsp")
mapn("<leader>n", ":20Lex<CR>")
-- rn defined in lsp.lua (other)
mapn("<leader>sh", ":split<CR>")
mapn("<leader>si", ":set cursorline!<CR>")
mapn("<leader>sl", ":set list!<CR>")
mapn("<leader>ss", ":set spell!<CR>")
mapn("<leader>sv", ":vsplit<CR>")
mapn("<leader>sx", ":close<CR>")
-- Items starting with "t" are reserved for Telescope
mapn("<leader>w", ":w<CR>")
mapn("<leader>W", ":set wrap!<CR>")

-- Move to beginning and end of line, ignoring spaces.

mapnx("<S-h>", "^")
mapnx("<S-l>", "g_")

-- Take the selection and move it up or down, after which, reselect the text,
-- reformat/indent it, and select it again.

mapv("J", ":m '>+1<CR>gv=gv")
mapv("K", ":m '<-2<CR>gv=gv")

-- Stay in visual mode when indenting.

mapv("<", "<gv")
mapv(">", ">gv")

-- Split navigation

mapn("<C-J>", "<C-W><C-J>")
mapn("<C-K>", "<C-W><C-K>")
mapn("<C-L>", "<C-W><C-L>")
mapn("<C-H>", "<C-W><C-H>")

-- Remap gf to open the file under the cursor even if it doesn't exist. This
-- tip is from the help for 'gf'. However, that help says to just use the 'map'
-- command. I'm not sure if that's the best way to go, so I'm using nnoremap.

mapn("gf", ":edit <cfile><cr>")

-- Remap commands to keep the found text centered. Use 'zv' to open folds in
-- case the selected text is hidden.

mapn("n", "nzzzv")
mapn("N", "Nzzzv")
mapn("*", "*zzzv")
mapn("#", "#zzzv")
mapn("g*", "g*zzzv")
mapn("g#", "g#zzzv")
mapn("<C-D>", "<C-D>zz")
mapn("<C-U>", "<C-U>zz")
-- mapn("<C-F>", "<C-F>zz") -- These changes turn these commands into
-- mapn("<C-B>", "<C-B>zz") -- C-D and C-U.

-- Tab / Shift-Tab to change buffers.

mapn("<Tab>", ":bnext<CR>")
mapn("<S-Tab>", ":bprevious<CR>")
mapn("<M-Tab>", "<c-^>") -- Edit alternate file
