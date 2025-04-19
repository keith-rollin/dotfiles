return {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
        keymap = {
            preset = "default",
            ["<C-c"] = { "cancel", "fallback" }, -- alias for <C-e>
        }
    },
}
