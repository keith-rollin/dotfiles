return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "BurntSushi/ripgrep",
    },
    config = function()
        require("telescope").setup({
            defaults = {
                path_display = { "filename_first" },
                file_ignore_patterns = { "__pycache__/" },
            },
        })

        kr.set_telescope_mapping()
    end,
}
