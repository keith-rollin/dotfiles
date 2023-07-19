-- https://github.com/khuedoan/dotfiles/blob/master/.config/nvim/lua/user/plugins.lua

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        print("Installing packer close and reopen Neovim...")
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- TODO: Add an autocmd to call PackerSync if this file is modified?
-- https://www.youtube.com/watch?v=gd_wapDL0V0&
-- https://youtu.be/m62UCkdQ8Ck?t=548
-- https://github.com/khuedoan/dotfiles/blob/master/.config/nvim/lua/user/plugins.lua

local packer_status_ok, packer = pcall(require, "packer")
local packer_util_status_ok, packer_util = pcall(require, "packer.util")
if not (packer_status_ok and packer_util_status_ok) then
    return
end

packer.init({
    compile_path = packer_util.join_paths(vim.fn.stdpath("data"), "plugin", "packer_compiled.lua"),
    display = {
        open_fn = function()
            return packer_util.float({ border = "rounded" })
        end,
    },
    git = {
        clone_timeout = 300, -- Timeout, in seconds, for git clones
    },
})

-- Plugins get installed to:
--
--      ~/.local/share/nvim/site/pack/packer/start

return packer.startup(function(use)
    use("wbthomason/packer.nvim") -- Packer can manage itself.

    use("nvim-lua/plenary.nvim") -- Pre-reqs for a lot of other plugins.
    use("nvim-lua/popup.nvim")

    use("ConradIrwin/vim-bracketed-paste") -- Handle BPM (bracketed paste mode -- see https://cirw.in/blog/bracketed-paste).
    use("derekwyatt/vim-fswitch") -- Switching between companion files.
    use("neovim/nvim-lspconfig") -- Quickstart configs for Nvim LSP
    use("tpope/vim-commentary") -- Comment/uncomment.
    use("tpope/vim-sensible") -- Sensible vim defaults.
    use("vim-autoformat/vim-autoformat") -- Provide easy code formatting in Vim by integrating existing code formatters. NOTE: needs pynvim installed in python.
    use("vim-scripts/indentpython.vim") -- PEP8 auto-indenting. TODO: This better handles ()'s, []'s, {}'s, and if/else, but doesn't handle long strings. Can I fix those issues?

    -- rust-tools
    use("simrat39/rust-tools.nvim") -- Tools for better development in rust using neovim's builtin lsp
    use("nvim-telescope/telescope.nvim")

    -- Treesitter
    use("nvim-treesitter/nvim-treesitter")
    use("nvim-treesitter/playground")

    -- Completion
    use("hrsh7th/nvim-cmp") -- A completion plugin for neovim coded in Lua.
    use("hrsh7th/cmp-buffer") -- nvim-cmp source for buffer words.
    use("hrsh7th/cmp-cmdline") -- nvim-cmp source for vim's cmdline.
    use("hrsh7th/cmp-nvim-lsp") -- nvim-cmp source for neovim builtin LSP client.
    use("hrsh7th/cmp-nvim-lua") -- nvim-cmp source for nvim lua.
    use("hrsh7th/cmp-path") -- nvim-cmp source for path.
    use("hrsh7th/cmp-vsnip") -- nvim-cmp source for vim-vsnip.
    use("hrsh7th/vim-vsnip") -- Snippet plugin for vim/nvim that supports LSP/VSCode's snippet format.

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins

    if packer_bootstrap then
        require("packer").sync()
    end
end)
