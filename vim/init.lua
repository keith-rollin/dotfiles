-- NOTES:
--  Things I want to note down, but don't really have any other place to put.
--
--  * Standard paths:
--
--      * stdpath(cache)        : $XDG_CACHE_HOME/nvim -> $HOME/.cache/nvim
--      * stdpath(config)       : $XDG_CONFIG_HOME/nvim -> $HOME/.config/nvim
--      * stdpath(config_dirs)  : $XDG_CONFIG_DIRS/nvim -> ['/usr/local/etc/xdg/nvim', '/etc/xdg/nvim']
--      * stdpath(data)         : $XDG_DATA_HOME/nvim -> $HOME/.local/share/nvim
--      * stdpath(data_dirs)    : $XDG_DATA_DIRS/nvim -> ['/usr/local/share/nvim', '/usr/share/nvim']
--      * stdpath(log)          : $XDG_STATE_HOME/nvim -> $HOME/.local/state/nvim
--      * stdpath(run)          : $XDG_RUNTIME_DIR/nvim.keith/... -> /var/folders/.../.../.../nvim.keith/...
--      * stdpath(state)        : $XDG_STATE_HOME/nvim -> $HOME/.local/state/nvim
--
--    So, the interesting ones are:
--
--      * .cache/nvim           : plugin storage
--      * .config/nvim          : init.lua and supporting scripts
--      * .local/share/nvim     : "user data directory" (Lazy, Mason, venv, etc.)
--      * .local/state/nvim     : drafts, swap, undo, shada, logs

-- Set mapleader here so that we can use it in all subsequent initialization.
-- This has to actually be defined before any place that uses it.

vim.g.mapleader = " "
vim.g.maplocalleader = " " -- Not really sure what this does, if anything

-- Set up the colorscheme. This is done before loading plugins so that they can
-- use the colorscheme if they want to.

vim.cmd.colorscheme("catppuccin")

-- A little global utility table.

_G.kr = {}

-- `vim.tbl_extend` takes a behavior for the first parameter. This behavior
-- determines what happens when there's a conflict merging two tables, and is
-- defined as:
--
-- • "error": raise an error
-- • "keep": use value from the leftmost map
-- • "force": use value from the rightmost map
--
-- I can never remember which means left and which means right, so define some
-- aliases.

kr.keep_left = "keep"
kr.keep_right = "force"


require("user.abbr")     -- Set our abbreviations (mostly to fix spelling errors)
require("user.events")   -- Set event handlers (e.g. respond to file loads/writes)
require("user.mapping")  -- Keyboard mappings
require("user.misc")     -- Stuuuuuffff
require("user.options")  -- Set our options ("set" and "setlocal" equivalents)
-- It's probably a good idea to require plugins last. It's a great place for
-- things to fail, and we would like that to happen after everything else is
-- set up and vim is feeling comfy.

require("user.packages") -- Download, install, configure, setup, etc., plugins
require("user.lsp")      -- Enable LSP servers. Do this after 'user.packages' so that nvim-lspconfig is available.


--
--
