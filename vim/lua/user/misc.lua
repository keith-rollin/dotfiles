--
-- `Match` spec for git merge error markers.
--
vim.cmd.match("ErrorMsg '^(<|=|>){7}([^=].+)?$'")

--
-- Customize the diagnostic display to show the source and error code along with
-- the error message.
--
-- TBD: Use vim.diagnostic.config.prefix or .suffix instead?
--
local function fmt(diagnostic)
    if diagnostic.code then
        return ("[%s] %s"):format(diagnostic.code, diagnostic.message)
    end
    return diagnostic.message
end

vim.diagnostic.config({
    virtual_text = {
        source = true,
        format = fmt,
    },
    float = {
        source = true,
        format = fmt,
    },
})

--
-- Originally from some old vim.org tip that I can't find any more.
-- Modified with trim_trailing_whitespace handler in
-- runtime/editor/lua/editorconfig.lua
--
kr.StripWhitespace = function()
    local oldquery = vim.fn.getreg("/")
    local view = vim.fn.winsaveview()
    vim.cmd("silent keepjumps keeppatterns %s/\\s\\+$//e")
    vim.fn.winrestview(view)
    vim.fn.setreg("/", oldquery)
end

-- Create a python virtual environment and use that for the python3 host
-- program used in nvim operations.

local function install_venv()
    local function check(system_obj, msg)
        local system_completed = system_obj:wait()
        if system_completed.code ~= 0 then
            print(msg)
            vim.print(system_completed)
            error(msg)
        end
    end

    local venv_dir = vim.fn.stdpath("data") .. "/venv"

    if not vim.fn.isdirectory(venv_dir) then
        check(vim.system({ "mkdir", "-p", venv_dir }), "Failed to create directory: " .. venv_dir)
    end

    if vim.fn.isdirectory(venv_dir .. "/.venv") == 0 then
        check(vim.system({ "uv", "venv", venv_dir .. "/.venv" }),
            "Failed to create virtual environment: " .. venv_dir .. "/.venv")
    end

    local files = vim.fn.glob(venv_dir .. "/.venv/lib/*", true, true)
    if not files or #files ~= 1 then
        error("Expected only one directory in " .. venv_dir .. "/.venv/lib, but found " .. #files)
    end

    if vim.fn.isdirectory(files[1] .. "/site-packages/pynvim") == 0 then
        check(vim.system({ "uv", "pip", "install", "-p", venv_dir .. "/.venv/bin/python3", "pynvim" }),
            "Failed to install pynvim in virtual environment: " .. venv_dir .. "/.venv")
    end

    vim.g.python3_host_prog = venv_dir .. "/.venv/bin/python3"
end

local _, _ = pcall(install_venv)

--
--
