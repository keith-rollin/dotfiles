return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "folke/which-key.nvim",
        },
        config = function()
            local dap = require("dap")

            -- Function keys on a Mac are awkward.
            -- Maybe move these to "<Leader>D"?
            -- kr.mapping.set_normal({
            --     ["<F5>"] = { dap.continue, "Continue" },
            --     ["<F10>"] = { dap.step_over, "Step Over" },
            --     ["<F11>"] = { dap.step_into, "Step Into" },
            --     ["<F12>"] = { dap.step_out, "Step Out" },
            -- })
            kr.mapping.set_normal({
                D = {
                    name = "Debug",
                    c = { dap.continue, "Continue" },
                    t = { dap.toggle_breakpoint, "Toggle Breakpoint" },
                    s = { dap.set_breakpoint, "Set Breakpoint" },

                    -- 'p', { function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, "???" },
                    -- 'r', { function() dap.repl.open() end, "Open REPL" },
                    -- 'l', { function() dap.run_last() end, "Run Last" },
                    -- 'h', { function() widgets.hover() end, "Hover" }, -- Also Visual mode?
                    -- 'p', { function() widgets.preview() end, "Preview" }, -- Also Visual mode?
                    -- 'f', { function() widgets.centered_float(widgets.frames) end, "Open Frames?" },
                    -- 's', { function() widgets.centered_float(widgets.scopes) end, "Open Scopes?" },
                },
            }, { prefix = "<leader>" })
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.before.attach.dapui_config = dapui.open
            dap.listeners.before.launch.dapui_config = dapui.open
            dap.listeners.before.event_terminated.dapui_config = dapui.close
            dap.listeners.before.event_exited.dapui_config = dapui.close
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            local dap_python = require("dap-python")
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python3"
            dap_python.setup(path)
        end,
    },
}
