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

utils.set_keymap_normal("<leader>.", "<c-^>")
utils.set_keymap_normal("<leader>,", ":FSHere<CR>")
utils.set_keymap_normal("<leader> ", ":lua StripWhitespace()<CR>")
utils.set_keymap_normal("<leader>af", ":Autoformat<CR>")
utils.set_keymap_normal("<leader>eg", ":edit ~/.gitconfig<CR>")
utils.set_keymap_normal("<leader>ev", ":edit " .. vim.env.MYVIMRC .. "<CR>")
utils.set_keymap_normal("<leader>ez", ":edit ~/.zshrc<CR>")
utils.set_keymap_normal("<leader>l", ":nohlsearch<CR>")
-- utils.set_keymap_normal("<leader>m",  ":call ParentMake()<CR>")
utils.set_keymap_normal("<leader>si", ":set cursorline!<CR>")
utils.set_keymap_normal("<leader>sl", ":set list!<CR>")
utils.set_keymap_normal("<leader>ss", ":set spell!<CR>")
utils.set_keymap_normal("<leader>w", ":w<CR>")

-- Find or replace the word under the cursor.

utils.set_keymap_normal("<leader>f", "/<C-r><C-w><CR>")
utils.set_keymap_normal("<leader>r", ":%s/<<C-r><C-w>>/<C-r><C-w>/g<Left><Left>")

-- Take the selection and move it up or down, after which, reselect the text,
-- reformat/indent it, and select it again.

utils.set_keymap_visual("J", ":m '>+1<CR>gv=gv")
utils.set_keymap_visual("K", ":m '<-2<CR>gv=gv")

-- Stay in visual mode when indenting.

utils.set_keymap_visual("<", "<gv")
utils.set_keymap_visual(">", ">gv")

-- Split navigation
--
-- NOTE: CTRL-L conflicts with vim-sensible's (and nvim's) mapping that removes
-- highlighting. I really like the latter and may miss it. For now, I've mapped
-- <leader>l to do most of the same thing (vim-sensible's version does more
-- than I need).

utils.set_keymap_normal("<C-J>", "<C-W><C-J>")
utils.set_keymap_normal("<C-K>", "<C-W><C-K>")
utils.set_keymap_normal("<C-L>", "<C-W><C-L>")
utils.set_keymap_normal("<C-H>", "<C-W><C-H>")

-- Remap gf to open the file under the cursor even if it doesn't exist. This
-- tip is from the help for 'gf'. However, that help says to just use the 'map'
-- command. I'm not sure if that's the best way to go, so I'm using nnoremap.

utils.set_keymap_normal("gf", ":edit <cfile><cr>")

-- Remap n and N to keep the found text centered.

utils.set_keymap_normal("n", "nzzzv")
utils.set_keymap_normal("N", "NzzzV")
