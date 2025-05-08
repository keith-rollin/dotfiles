return {
    "neovim/nvim-lspconfig",
    config = function()
        -- Set up the sourcekit LSP server. This is used for Swift. Note that we
        -- can't install this via mason-tool-installer since that plugin doesn't
        -- know about sourcekit--it's already installed with swift. So we need
        -- to initialize it "out of band". See:
        --
        --      https://www.swift.org/documentation/articles/zero-to-swift-nvim.html
        --
        -- Note that that article may be a bit out of date. Under "File
        -- Updating", it recommends setting `dynamicRegistration` to true.
        -- However, the following nvim bug report indicates that nvim now
        -- supports dynamic registration:
        --
        --      https://github.com/neovim/nvim-lspconfig/issues/2807#issuecomment-1716433221
        --
        -- I've been running with `dynamicRegistration` set to false and it
        -- seems to be working fine.

        local lspconfig = require('lspconfig')
        lspconfig.sourcekit.setup {}
    end,
}
