-- Some locations listing some mappings nvim sets up:
--
--  `:help default-mappings`
--  `:help grx`

local setn = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { noremap = true, silent = true, desc = desc })
end

local setnx = function(lhs, rhs, desc)
    vim.keymap.set({ "n", "x" }, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

local setv = function(lhs, rhs, desc)
    vim.keymap.set("v", lhs, rhs, { noremap = true, silent = true, desc = desc })
end

--
-- Miscellaneous custom mappings
--
setn("<leader> ", "<cmd>lua kr.StripWhitespace()<CR>", "Strip trailing white space")
setn("<leader>,", "<cmd>FSHere<CR>", "Switch to paired file")
setn("<leader>.", "<c-^>", "Edit alternate file")
setn("<leader>ee", "<cmd>edit ~/.config/ghostty/config<CR>", "Ghostty config")
setn("<leader>eg", "<cmd>edit ~/.gitconfig<CR>", ".gitconfig")
setn("<leader>ev", "<cmd>edit " .. vim.env.MYVIMRC .. "<CR>", "init.lua")
setn("<leader>ez", "<cmd>edit ~/.zshrc<CR>", ".zshrc")
setn("<leader>ru", "<cmd>:.lua<CR>", "Run current line")
setn("<leader>ss", "<cmd>set spell!<CR>", "Toggle 'spell'")
setn("<leader>sw", "<cmd>set wrap!<CR>", "Toggle line wrapping")
setn("<leader>w", "<cmd>w<CR>", "Write current file")

--
-- Copilot mappings
-- Called from Copilot setup function.
--
kr.set_copilot_mapping = function()
    setn("<leader>cd", "<cmd>Copilot disable<CR><cmd>Copilot status<CR>", "Disable")
    setn("<leader>ce", "<cmd>Copilot enable<CR><cmd>Copilot status<CR>", "Enable")
    setn("<leader>cs", "<cmd>Copilot status<CR>", "Status")
end

--
-- FZF mappings
-- Called from FZF setup function.
--
kr.set_fzf_mapping = function(fzf_lua)
    -- See `:help fzf-lua` for more commands to map.
    setn("<leader>fb", fzf_lua.buffers, "Find buffers")
    setn("<leader>ff", fzf_lua.files, "Find files")
    setn("<leader>fg", fzf_lua.live_grep, "Grep current project")
end
--
-- Split management mappings
--
setn("<C-h>", "<C-w><C-h>", "Move to the window to the left")
setn("<C-j>", "<C-w><C-j>", "Move to the window below")
setn("<C-k>", "<C-w><C-k>", "Move to the window above")
setn("<C-l>", "<C-w><C-l>", "Move to the window to the right")

setn("<S-Up>", ":resize -2<CR>", "Decrease window height")
setn("<S-Down>", ":resize +2<CR>", "Increase window height")
setn("<S-Left>", ":vertical resize -2<CR>", "Decrease window width")
setn("<S-Right>", ":vertical resize +2<CR>", "Increase window width")

--
-- Line navigation mappings
--
setnx("H", "^", "Alias for ^")
setnx("L", "g_", "Alias for g_")

--
-- Tab / Shift-Tab to change buffers.
--
setn("<M-Tab>", "<c-^>", "Edit alternate file")
setn("<S-Tab>", "<cmd>bprevious<CR>", "Previous buffer")
setn("<Tab>", "<cmd>bnext<CR>", "Next buffer")

--
-- Remove search highlight.
--
setn("<ESC>", "<cmd>nohlsearch<CR>", "Disable highlight")

--
-- Change ZZ to not winge about not having visited every buffer.
--
setn("ZZ", "<cmd>xa<cr>", "Quit without whining")

--
-- Remap gf to open the file under the cursor even if it doesn't exist. This tip
-- is from the help for 'gf'. However, that help says to just use the 'map'
-- command. I'm not sure if that's the best way to go, so I'm using nnoremap.
--
setn("gf", "<cmd>edit <cfile><cr>", "Edit file under cursor")

--
-- Visual mode mappings
--
setv("<", "<gv", "Stay in visual mode when indenting")
setv(">", ">gv", "Stay in visual mode when indenting")

setv("J", ":m '>+1<CR>gv=gv", "Move selected lines down")
setv("K", ":m '<-2<CR>gv=gv", "Move selected lines up")

--
-- Retain cursor position when joining lines.
--
setn("J", "mzJ`z", "Join lines without moving cursor")

--
--
