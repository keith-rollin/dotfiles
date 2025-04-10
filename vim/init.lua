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

-- Create a python virtual environment and use that for the python3 host
-- program used in nvim operations.

local function install_venv()
    local function check(system_obj, msg)
        local system_completed = system_obj:wait()
        if system_completed.code ~= 0 then
            print(msg)
            vim.print(system_completed)
            error(msg)
        end
    end

    local venv_dir = vim.fn.stdpath("data") .. "/venv"

    if not vim.fn.isdirectory(venv_dir) then
        check(vim.system({ "mkdir", "-p", venv_dir }), "Failed to create directory: " .. venv_dir)
    end

    if vim.fn.isdirectory(venv_dir .. "/.venv") == 0 then
        check(vim.system({ "uv", "venv", venv_dir .. "/.venv" }),
            "Failed to create virtual environment: " .. venv_dir .. "/.venv")
    end

    local files = vim.fn.glob(venv_dir .. "/.venv/lib/*", true, true)
    if not files or #files ~= 1 then
        error("Expected only one directory in " .. venv_dir .. "/.venv/lib, but found " .. #files)
    end

    if vim.fn.isdirectory(files[1] .. "/site-packages/pynvim") == 0 then
        check(vim.system({ "uv", "pip", "install", "-p", venv_dir .. "/.venv/bin/python3", "pynvim" }),
            "Failed to install pynvim in virtual environment: " .. venv_dir .. "/.venv")
    end

    vim.g.python3_host_prog = venv_dir .. "/.venv/bin/python3"
end

local _, _ = pcall(install_venv)

-- Set mapleader here so that we can use it in all subsequent initialization.
-- This has to actually be defined before any place that uses it.

vim.g.mapleader = " "
vim.g.maplocalleader = " " -- Not really sure what this does, if anything

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


-- It's probably a good idea to require plugins last. It's a great place for
-- things to fail, and we would like that to happen after everything else is
-- set up and vim is feeling comfy.

require("user.abbr")                      -- Set our abbreviations (mostly to fix spelling errors)
require("user.events")                    -- Set event handlers (e.g. respond to file loads/writes)
require("user.mapping")                   -- Keyboard mappings
require("user.misc")                      -- Stuuuuuffff
require("user.options")                   -- Set our options ("set" and "setlocal" equivalents)
require("user.prelazy")                   -- Define 'spec' function

spec("user.plugins.blink-cmp")            -- Completion
spec("user.plugins.copilot")              -- Neovim plugin for GitHub Copilot
spec("user.plugins.conform")              -- Formatting
spec("user.plugins.indent-blankline")     -- Indent guides for Neovim
spec("user.plugins.mason")                -- mason
spec("user.plugins.mason-lspconfig")      -- mason-lspconfig
spec("user.plugins.mason-tool-installer") -- Downloading LSP servers, linters, formatters, etc.
spec("user.plugins.nvim-treesitter")      -- Nvim Treesitter configurations and abstraction layer
spec("user.plugins.nvim-treesitter-textobjects")
spec("user.plugins.telescope")            -- Find, Filter, Preview, Pick.
spec("user.plugins.trouble")              -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
spec("user.plugins.which-key")            -- Create key bindings that stick. WhichKey helps you remember your Neovim keymaps, by showing available keybindings in a popup as you type.

require("user.lazy")                      -- Download, install, configure, setup, etc., plugins

--
--
