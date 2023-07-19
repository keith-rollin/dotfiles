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
--      * .local/share/nvim     : "user data directory"
--      * .local/state/nvim     : drafts, swap, undo, shada, logs

-- Set mapleader here so that we can use it anywhere in the file (even outside
-- of keymap.lua). This has to actually be defined before any place that uses it.

vim.g.mapleader = " "

-- Load plugins

require("plugins")

-- Initialize plugins

require("init-lsp")
require("init-autoformat")
require("init-telescope")
require("init-treesitter")
require("init-rusttools")

-- Other initialization

require("options") -- Set our options ("set" and "setlocal" equivalents)
require("keymap") -- Set our custom key bindings
require("events") -- Set event handlers (e.g. respond to file loads/writes)
require("abbr") -- Set out abbreviations (mostly to fix spelling errors)
require("misc") -- Stuuuuuffff
