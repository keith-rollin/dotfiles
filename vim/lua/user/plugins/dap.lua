return {
    {
        "rcarriga/nvim-dap-ui",
    },
    {
        "mfussenegger/nvim-dap-python",
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "mfussenegger/nvim-dap-python",
            "folke/which-key.nvim",
        },
        config = function()
            local dap = require("dap")
            -- local widgets = require("dap.widgets")
            local dapui = require("dapui")
            local dap_python = require("dap-python")

            dapui.setup()
            dap_python.setup("~/.local/virtualenvs/debugpy/bin/python3")

            dap.listeners.before.attach.dapui_config = dapui.open
            dap.listeners.before.launch.dapui_config = dapui.open
            dap.listeners.before.event_terminated.dapui_config = dapui.close
            dap.listeners.before.event_exited.dapui_config = dapui.close

            -- Maybe move these to "<Leader>D"?
            kr.mapping.set_normal({
                ["<F5>"] = { dap.continue, "Continue" },
                ["<F10>"] = { dap.step_over, "Step Over" },
                ["<F11>"] = { dap.step_into, "Step Into" },
                ["<F12>"] = { dap.step_out, "Step Out" },
            })
            kr.mapping.set_normal_leader({
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
            })
        end,
    },
}
