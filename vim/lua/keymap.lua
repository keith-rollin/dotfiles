-- Custom keys
-- -----------

-- Cheat Sheet (from `:help :map-modes`):
--
-- There are six sets of mappings:
--
-- - For Normal mode: When typing commands.
-- - For Visual mode: When typing commands while the Visual area is highlighted.
-- - For Select mode: like Visual mode but typing text replaces the selection.
-- - For Operator-pending mode: When an operator is pending (after "d", "y", "c",
--   etc.).
-- - For Insert mode: These are also used in Replace mode.
-- - For Command-line mode: When entering a ":" or "/" command. (KR: And, I
--   suspect, "!" commands.)
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
--
-- Use *noremap when recursive mapping is not wanted. Use *unmap to remove a
-- specified binding. Use *mapclear to remove all bindings for that mode.
--
-- Nvim creates the following default mappings (distinct from Vim)
-- See `:help default-mappings`
-- Note that I override <C-L> to move between windows, and so use <Leader>l to
-- remove highlighting instead.
--
--      nnoremap Y y$
--      nnoremap <C-L> <Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>
--      inoremap <C-U> <C-G>u<C-U>
--      inoremap <C-W> <C-G>u<C-W>
--      xnoremap * y/\V<C-R>"<CR>
--      xnoremap # y?\V<C-R>"<CR>
--      nnoremap & :&&<CR>

local utils = require("utils")
local mapn = utils.set_keymap_normal
local mapv = utils.set_keymap_visual

-- do, dp, dn, dl defined in init-mason
-- gD, gd, gi, gt defined in init-mason
-- ca, ff, K, rn, sh*, sr defined in init-mason
-- Items starting with "t" are reserved for Telescope
-- * Removed so that we can use it below.

mapn("<leader>.", "<c-^>")
mapn("<leader>,", ":FSHere<CR>")
mapn("<leader> ", ":lua StripWhitespace()<CR>")
mapn("<leader>eg", ":edit ~/.gitconfig<CR>")
mapn("<leader>ev", ":edit " .. vim.env.MYVIMRC .. "<CR>")
mapn("<leader>ez", ":edit ~/.zshrc<CR>")
mapn("<leader>l", ":nohlsearch<CR>")
mapn("<leader>sh", ":split<CR>")
mapn("<leader>si", ":set cursorline!<CR>")
mapn("<leader>sl", ":set list!<CR>")
mapn("<leader>ss", ":set spell!<CR>")
mapn("<leader>sv", ":vsplit<CR>")
mapn("<leader>sx", ":close<CR>")
mapn("<leader>w", ":w<CR>")

-- Find or replace the word under the cursor.

mapn("<leader>f", "/<C-r><C-w><CR>")
mapn("<leader>r", ":%s/<<C-r><C-w>>/<C-r><C-w>/g<Left><Left>")

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

-- Remap n and N to keep the found text centered.

mapn("n", "nzzzv")
mapn("N", "NzzzV")


-- Tab / Shift-Tab to change buffers.

mapn("<Tab>", ":bnext<CR>")
mapn("<S-Tab>", ":bprevious<CR>")

-- Space-n toggles netrw tree view

mapn("<leader>n", ":20Lex<CR>")
