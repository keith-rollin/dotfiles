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
--
-- TODO: Check out the following:
--      * Neovide: https://neovide.dev/
--      * LazyVim: https://lazyvim.org https://github.com/LazyVim/LazyVim
--      * LunarVim: https://github.com/LunarVim/LunarVim
--      * AstroNvim: https://github.com/AstroNvim/AstroNvim
--      * NvChad: https://github.com/NvChad/NvChad
--      * Kickstart: https://github.com/nvim-lua/kickstart.nvim
--      * SpaceVim: https://spacevim.org/
--      * CosmicNvim: https://github.com/CosmicNvim/CosmicNvim
--      * lsp-zero: https://github.com/VonHeikemen/lsp-zero.nvim
--      * Awesome Neovim: https://github.com/rockerBOO/awesome-neovim

-- Set mapleader here so that we can use it anywhere in the file (even outside
-- of keymap.lua). This has to actually be defined before any place that uses
-- it.

vim.g.mapleader = " "
vim.g.maplocalleader = " " -- Not really sure what this does, if anything

-- It's probably a good idea to require plugins last. It's a great place for
-- things to fail, and we would like that to happen after everything else is
-- set up and vim is feeling comfy.

require("user.abbr")    -- Set our abbreviations (mostly to fix spelling errors)
require("user.events")  -- Set event handlers (e.g. respond to file loads/writes)
require("user.keymap")  -- Set our custom key bindings
require("user.misc")    -- Stuuuuuffff
require("user.options") -- Set our options ("set" and "setlocal" equivalents)
require("user.prelazy") -- Define 'spec' function
spec("user.plugins.completion")
spec("user.plugins.lsp")
spec("user.plugins.misc")
spec("user.plugins.popup")
spec("user.plugins.telescope")
spec("user.plugins.treesitter")
require("user.lazy") -- Download, install, configure, setup, etc., plugins
