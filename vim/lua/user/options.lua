-- Options

vim.opt.autoindent = true         -- Normally 'autoindent' should also be on when using 'smartindent'.
vim.opt.autowriteall = true       -- Write the file when we switch buffers.
vim.opt.clipboard = "unnamedplus" -- Interoperate with the system clipboard.
-- vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.cursorline = true         -- Highlight the current line.
vim.opt.grepprg = "rg --vimgrep"  -- Use ripgrep for grepping.
vim.opt.list = true               -- Show invisible characters.
vim.opt.listchars = { tab = "▸ ", trail = "•", nbsp = "∆", }
vim.opt.mouse = "a"               -- Use mouse in all (normal, visual, insert, command) modes.
vim.opt.path:append({ "**" })     -- Recursively search subdirectories for files on tab-complete.
vim.opt.pumborder = "single"      -- Default popup window border style.
vim.opt.scrolloff = 1             -- Keep at least 1 line above and below the cursor.
vim.opt.shiftround = true         -- Round indent to multiple of 'shiftwidth'.
vim.opt.shortmess = "atI"         -- Don't show the intro message when starting Vim.
vim.opt.showmode = false          -- Don't show mode (insert, replace, etc.) in the command line.
vim.opt.smartindent = true        -- Indent like C-like programs.
vim.opt.splitbelow = true         -- New horizontal splits appear below.
vim.opt.splitright = true         -- New vertical splits appear to the right.
vim.opt.title = true              -- Set window title.
vim.opt.undofile = true           -- Persistent undo
vim.opt.updatetime = 250          -- Write to the swap file more quickly.
vim.opt.winborder = "single"      -- Default window border style.
vim.opt.wrap = false              -- Don't wrap text at the right side of the screen.

-- Installation instructions for fzf say:
--
--      "To use fzf in Vim, add the following line to your .vimrc:"

vim.opt.rtp:prepend("/opt/homebrew/opt/fzf")

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

-- autocomplete related

-- vim.opt.autocomplete = false
-- vim.opt.pumheight = 10

-- netrw: Configuration

vim.g.netrw_banner = 0       -- Disable banner.
vim.g.netrw_liststyle = 3    -- Tree view.
vim.g.netrw_browse_split = 4 -- Open in previous window
vim.g.netrw_list_hide = "\z
    \\(^\\|\\s\\s\\)\z
    \\zs\z
    \\(\z
        \\(.git\\)\\|\z
        \\(.DS_Store\\)\\|\z
        \\(venv\\)\\|\z
        \\(__pycache__\\)\\|\z
        \\(.*\\.egg-info\\)\z
    \\)"

--
--
