return {
    'stevearc/conform.nvim',
    opts = {
        default_format_opts = {
            lsp_format = "fallback",
        },
        formatters_by_ft = {
            python = { "ruff", "isort" },
        },
        format_on_save = {},
    },
}
