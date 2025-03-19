-- Options

vim.opt.autoindent = true         -- Normally 'autoindent' should also be on when using 'smartindent'.
vim.opt.autowriteall = true       -- Write the file when we switch buffers.
vim.opt.clipboard = "unnamedplus" -- Interoperate with the system clipboard.
vim.opt.completeopt = {           -- Mostly for "cmp"
    "menu",
    "menuone",
    "noselect" }
vim.opt.cursorline = true        -- Highlight the current line.
vim.opt.grepprg = "rg --vimgrep" -- Use ripgrep for grepping.
vim.opt.list = true              -- Show invisible characters.

vim.opt.listchars = {
    tab = "▸ ", -- Show TABs as RIGHT-ARROW + SPACEs. (Overrides vim-sensible)
    trail = "•", -- Show trailing spaces as bullets. (Overrides vim-sensible)
    nbsp = "∆", -- Show non-breaking spaces as deltas. (Overrides vim-sensible)
}

vim.opt.mouse = "a"           -- Use mouse in all (normal, visual, insert, command) modes.
vim.opt.path:append({ "**" }) -- Recursively search subdirectories for files on tab-complete.
vim.opt.shiftround = true     -- Round indent to multiple of 'shiftwidth'.
vim.opt.shortmess = "atI"     -- Don't show the intro message when starting Vim.
vim.opt.smartindent = true    -- Indent like C-like programs.
vim.opt.splitbelow = true     -- New horizontal splits appear below.
vim.opt.splitright = true     -- New vertical splits appear to the right.
vim.opt.title = true          -- Set window title.
vim.opt.undofile = true       -- Persistent undo
vim.opt.wrap = false          -- Don't wrap text at the right side of the screen.

-- Search/replace related

vim.opt.ignorecase = true    -- Ignore case of text and tag searches.
vim.opt.inccommand = "split" -- Show prospective changed lines in a split.
vim.opt.smartcase = true     -- Case-insensitive searching unless we type at least one capital letter.

-- Line number related.

vim.opt.number = true         -- Show absolute line numbers.
vim.opt.relativenumber = true -- Show relative line numbers; w/ above, accommodates both.

-- TAB related

vim.opt.expandtab = true -- Convert tabs to spaces.
vim.opt.shiftwidth = 4   -- Number of spaces to use for each step of (auto)indent.
vim.opt.softtabstop = 4  -- Number of spaces in tab when editing.
vim.opt.tabstop = 4      -- Number of visual spaces per TAB.

-- netrw: Configuration

vim.g.netrw_banner = 0       -- Disable banner.
vim.g.netrw_liststyle = 3    -- Tree view.
vim.g.netrw_browse_split = 4 -- Open in previous window
vim.g.netrw_list_hide =
"\\(^\\|\\s\\s\\)\\zs\\(\\(.git\\)\\|\\(.DS_Store\\)\\|\\(venv\\)\\|\\(__pycache__\\)\\|\\(.*\\.egg-info\\)\\)"

-- New option as of: Mar 18, 2025
-- https://github.com/neovim/neovim/commit/62d9fab9af21323e42828748e6761c02020a7aa5
-- To appear in Neovim 0.11.0
vim.o.winborder = 'single'

--
--
--
