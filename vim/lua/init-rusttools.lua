local rusttools_status_ok, rusttools = pcall(require, "rust-tools")
if not rusttools_status_ok then
    return
end

local do_map = function(keys, fn)
    vim.keymap.set("n", "<leader>" .. keys, fn, { noremap = true, silent = true, buffer = bufnr })
end

rusttools.setup({
    server = {
        cmd = { "rustup", "run", "stable", "rust-analyzer" },
        on_attach = function(_, bufnr)
            do_map("gc", rusttools.open_cargo_toml.open_cargo_toml)
            do_map("gd", vim.lsp.buf.definition)
            do_map("gi", vim.lsp.buf.implementation)
            do_map("gt", vim.lsp.buf.type_definition)
            do_map("sr", vim.lsp.buf.references)
            do_map("sh", vim.lsp.buf.signature_help)
            do_map("K", vim.lsp.buf.hover)
            do_map("rn", vim.lsp.buf.rename)
            -- do_map("ff", vim.lsp.buf.formatting) -- We get this when saving.
            do_map("ca", vim.lsp.buf.code_action) -- Use rust-tools's?
        end,
    },
    tools = {
        inlay_hints = {
            highlight = "DiagnosticHint",
        },
    },
})
