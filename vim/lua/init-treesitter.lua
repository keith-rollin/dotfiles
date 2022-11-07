local treesitter_configs_status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not treesitter_configs_status_ok then
    return
end

-- Maybe install treesitter extensions like rainbow or playground:
-- https://youtu.be/hkxPa5w3bZ0?t=430

treesitter_configs.setup({

    -- NOTE: Except for C, Lua,and Vim, these are installed into the following
    -- location. The other three are built into (or provided with) nvim itself.
    --
    --      ~/.local/share/nvim/site/pack/packer/start/nvim-treesitter/parser

    ensure_installed = {
        "bash",
        "c",
        "cpp",
        -- "gitignore", -- Requires Node
        "http",
        "json",
        "lua",
        "make",
        "markdown",
        "python",
        "rust",
        -- "swift", -- Requires Node
        "toml",
        "vim",
    },
    indent = { enable = true },
})
