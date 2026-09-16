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
setn("<leader>Sh", "<cmd>split<CR>", "Split horizontally")
setn("<leader>Sv", "<cmd>vsplit<CR>", "Split vertically")
setn("<leader>Sx", "<cmd>close<CR>", "Close split")
setn("<leader>ee", "<cmd>edit ~/.config/ghostty/config<CR>", "Ghostty config")
setn("<leader>eg", "<cmd>edit ~/.gitconfig<CR>", ".gitconfig")
setn("<leader>ev", "<cmd>edit " .. vim.env.MYVIMRC .. "<CR>", "init.lua")
setn("<leader>ez", "<cmd>edit ~/.zshrc<CR>", ".zshrc")
setn("<leader>ff", function() require("conform").format() end, "Format file")
setn("<leader>im", "<cmd>Mason<CR>", "Mason")
setn("<leader>iz", "<cmd>Lazy<CR>", "Lazy")
-- Defined in treesitter-textobjects.lua
-- ["<leader>sa"] = { query = "@parameter.inner", desc = "Swap with next parameter" },
-- ["<leader>sA"] = { query = "@parameter.inner", desc = "Swap with previous parameter" },
setn("<leader>si", "<cmd>set cursorline!<CR>", "Toggle 'cursorline'")
setn("<leader>sl", "<cmd>set list!<CR>", "Toggle 'list'")
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
-- Diagnostics mappings
-- Called from LSP setup function.
--
kr.set_diagnostic_mapping = function()
    setn("<leader>dl", vim.diagnostic.setloclist, "Set location list")
    setn("<leader>dn", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Go to next diagnostic")      -- Similar to ]d
    setn("<leader>do", vim.diagnostic.open_float, "Show diagnostics")
    setn("<leader>dp", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Go to previous diagnostic") -- Similar to [d
end

--
-- LSP mappings
-- Called from LSP setup function.
--
-- These are named to be consistent with the new gra, gri, grn, and grr
-- keybindings in Neovim 0.11.
--
kr.set_lsp_mapping = function()
    setn("grd", vim.lsp.buf.definition, "Go to definition")
    setn("grD", vim.lsp.buf.declaration, "Go to declaraction")
    setn("grs", vim.lsp.buf.signature_help, "Show signature help")
    setn("grt", vim.lsp.buf.type_definition, "Go to type definition")
end

--
-- Trouble mappings
-- Called from Trouble setup function.
--
kr.set_trouble_mapping = function()
    setn("<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", "Trouble: diagnostics")
    setn("<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", "Trouble: buffer diagnostics")
    setn("<leader>xs", "<cmd>Trouble diagnostics toggle focus=false<CR>", "Trouble: symbols")
    setn("<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
        "Trouble: LSP Definitions / references / ...")
    setn("<leader>xL", "<cmd>Trouble loclist toggle<CR>", "Trouble: Location list")
    setn("<leader>xQ", "<cmd>Trouble qflist toggle<CR>", "Trouble: Quickfix list")
end

--
-- Telescope mappings
-- Called from Telescope setup function.
--
kr.set_telescope_mapping = function()
    setn("<leader>tf*", "<cmd>Telescope grep_string<CR>", "Search directory for string under cursor")
    setn("<leader>tfc", "<cmd>Telescope current_buffer_fuzzy_find<CR>", "Fuzzy search in current buffer")
    setn("<leader>tff", "<cmd>Telescope find_files<CR>", "Search for files")
    setn("<leader>tfg", "<cmd>Telescope live_grep<CR>", "Search for string")
    setn("<leader>tft", "<cmd>Telescope treesitter<CR>", "Show Treesitter query results")
    setn("<leader>tLS", "<cmd>Telescope lsp_workspace_symbols<CR>", "List document symbols in workspace")
    setn("<leader>tlI", "<cmd>Telescope lsp_incoming_calls<CR>", "List incoming calls for hot string")
    setn("<leader>tld", "<cmd>Telescope lsp_definitions<CR>", "Go to definition for hot string")
    setn("<leader>tli", "<cmd>Telescope lsp_implementation<CR>", "Go to implementation for hot string")
    setn("<leader>tlo", "<cmd>Telescope lsp_outgoing_calls<CR>", "List outgoing calls for hot string")
    setn("<leader>tlr", "<cmd>Telescope lsp_references<CR>", "List references for hot string")
    setn("<leader>tls", "<cmd>Telescope lsp_document_symbols<CR>", "List document symbols in current buffer")
    setn("<leader>tlt", "<cmd>Telescope lsp_type_definitions<CR>", "Go to type definition for hot string")
    setn("<leader>ttc", "<cmd>Telescope current_buffer_tags<CR>", "List tags in current buffer")
    setn("<leader>ttt", "<cmd>Telescope tags<CR>", "List tags in current directory")
    setn("<leader>tgB", "<cmd>Telescope git_bcommits<CR>", "Show commits for current buffer")
    setn("<leader>tgS", "<cmd>Telescope git_stash<CR>", "Show stash")
    setn("<leader>tgb", "<cmd>Telescope git_branches<CR>", "Show branches")
    setn("<leader>tgc", "<cmd>Telescope git_commits<CR>", "Show commits")
    setn("<leader>tgf", "<cmd>Telescope git_files<CR>", "Show files tracked by git")
    setn("<leader>tgs", "<cmd>Telescope git_status<CR>", "Show status")
    setn("<leader>tpb", "<cmd>Telescope builtin<CR>", "Show builtin pickers")
    setn("<leader>tpr", "<cmd>Telescope resume<CR>", "Resume the previous picker")
    setn("<leader>tk", "<cmd>Telescope keymaps<CR>", "Show normal mode keymaps")
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
-- Remap gf to open the file under the cursor even if it doesn't
-- exist. This tip is from the help for 'gf'. However, that help
-- says to just use the 'map' command. I'm not sure if that's the
-- best way to go, so I'm using nnoremap.
--
setn("gf", "<cmd>edit <cfile><cr>", "Edit file under cursor")

--
-- Visual mode mappings
--
setv("<", "<gv", "Stay in visual mode when indenting")
setv(">", ">gv", "Stay in visual mode when indenting")

--
--
--
