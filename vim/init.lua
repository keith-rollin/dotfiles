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
