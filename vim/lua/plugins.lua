-- More plugins to investigate, including those for rust integration:
--      https://github.com/cpow/cpow-dotfiles
--      https://github.com/ChristianChiarulli/nvim
--
-- "echasnovski/mini.nvim"  -- The Tim Pope of Lua, and then some!
-- "simrat39/rust-tools.nvim", -- Tools for better development in rust using neovim's builtin lsp
-- "nvim-neo-tree/neo-tree.nvim"
-- "nvim-tree/nvim-tree.lua",
-- "nvim-lualine/lualine.nvim",
-- "kyazdani42/nvim-web-devicons",
-- { "glepnir/lspsaga.nvim", branch = "main" } -- See the following for keybindings: https://youtu.be/vdn_pKJUda8?si=VXnW4xurpH3O4Tcy&t=3106
-- "windwp/nvim-autopairs",
-- "lewis6991/gitsigns.nvim",

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

require("lazy").setup("init_plugins", {

    -- Move the lazy-lock file from my vim directory to the share directory
    -- so that I don't have to deal with version controlling it in git.
    -- Some people may want to do that, but I don't think it's for me.

    lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json",

    ui = {
        border = "rounded",
        change_detection = {
            enabled = true,
            notify = false,
        },
        icons = {
            loaded = "•",
            not_loaded = "o",
            task = "√ ",
            list = { "•", ">", "*", "-" },
        },
    },
})
