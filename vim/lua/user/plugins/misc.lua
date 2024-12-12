return {
    "derekwyatt/vim-fswitch",
    "tpope/vim-sensible",
    "kovisoft/paredit",

    -- Doesn't work along with treesitter's highlighting
    -- https://github.com/luochen1990/rainbow/issues/163
    -- Also see the following for treesitter's rainbow plugin:
    -- https://github.com/p00f/nvim-ts-rainbow/issues/142
    -- Note that nvim-treesitter's documentation mentions support for external
    -- modules, and lists the following as an example:
    -- https://github.com/HiPhish/nvim-ts-rainbow2
    -- However, that project says that it's deprecated as nvim-treesitter no
    -- longer supports external modules. Who's right?
    -- "luochen1990/rainbow",

    -- Maybe try this one.
    -- "HiPhish/rainbow-delimiters.nvim",
}
