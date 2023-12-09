-- https://github.com/folke/lazy.nvim

-- TODO: When starting up from scratch, some repositories are successfully
--       cloned, but then block at some point (during checkout?). Why is this
--       happening?
-- TODO: It seems that not everything is properly initialized on a clean
--       startup. In particular, my colorscheme is not set. Why?
-- TODO: Investigate the plugins referenced on the lazy.nvim github page.
--       Re-evaluate the plugins I use below. It's been a while since I added
--       them to my lists. Are they still the cutting edge, or have they been
--       superseded?
--
-- Clear out the installation by deleting ~/.local/{state,share}/nvim/lazy

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

plugins = {
    "nvim-lua/plenary.nvim", -- Pre-reqs for a lot of other plugins.
    "nvim-lua/popup.nvim",

    "ConradIrwin/vim-bracketed-paste", -- Handle BPM (bracketed paste mode -- see https://cirw.in/blog/bracketed-paste).
    "derekwyatt/vim-fswitch", -- Switching between companion files.
    "neovim/nvim-lspconfig", -- Quickstart configs for Nvim LSP
    "tpope/vim-commentary", -- Comment/uncomment.
    "tpope/vim-sensible", -- Sensible vim defaults.
    "vim-autoformat/vim-autoformat", -- Provide easy code formatting in Vim by integrating existing code formatters. NOTE: needs pynvim installed in python.
    "vim-scripts/indentpython.vim", -- PEP8 auto-indenting. TODO: This better handles ()'s, []'s, {}'s, and if/else, but doesn't handle long strings. Can I fix those issues?

    -- rust-tools
    "simrat39/rust-tools.nvim", -- Tools for better development in rust using neovim's builtin lsp
    "nvim-telescope/telescope.nvim",

    -- Treesitter
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/playground",

    -- Completion
    "hrsh7th/nvim-cmp", -- A completion plugin for neovim coded in Lua.
    "hrsh7th/cmp-buffer", -- nvim-cmp source for buffer words.
    "hrsh7th/cmp-cmdline", -- nvim-cmp source for vim's cmdline.
    "hrsh7th/cmp-nvim-lsp", -- nvim-cmp source for neovim builtin LSP client.
    "hrsh7th/cmp-nvim-lua", -- nvim-cmp source for nvim lua.
    "hrsh7th/cmp-path", -- nvim-cmp source for path.
    "hrsh7th/cmp-vsnip", -- nvim-cmp source for vim-vsnip.
    "hrsh7th/vim-vsnip", -- Snippet plugin for vim/nvim that supports LSP/VSCode's snippet format.
}

opts = {
    lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json",
    ui = {
        icons = {
            loaded = "•",
            not_loaded = "o",
            task = "√ ",
            list = {
                "•",
                ">",
                "*",
                "-",
            },
        },
        custom_keys = {
            ["<localleader>L"] = {
                function(plugin)
                    require("lazy.util").float_term({ "lazygit", "log" }, {
                        cwd = plugin.dir,
                    })
                end,
                desc = "Open lazygit log",
            },
        },
    },
}

require("lazy").setup(plugins, opts)
