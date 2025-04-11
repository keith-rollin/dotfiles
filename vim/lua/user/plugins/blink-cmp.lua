return {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
        keymap = {
            preset = "default",
            ["<CR>"] = { "accept", "fallback" }, -- alias for <C-y>
            ["<C-c"] = { "cancel", "fallback" }, -- alias for <C-e>
        }
    },
}
