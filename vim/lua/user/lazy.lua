local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- Complains about fs_stat
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

    spec = "user.plugins",

    -- Move the lazy-lock file from my vim directory to the share directory so
    -- that I don't have to deal with version controlling it in git. Some people
    -- may want to do that, but I don't think it's for me.

    lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json",

    ui = {
        border = "double",
    },
})
