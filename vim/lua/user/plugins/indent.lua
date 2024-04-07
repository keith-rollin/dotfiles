return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
        indent = {
            -- char = "▏",
            -- char = "│",
            -- char = "▕",
            char = "┊",
            -- char = "╎",
            highlight = { "DiagnosticHint" },
        },
        scope = {
            enabled = false,
        },
    },
}
