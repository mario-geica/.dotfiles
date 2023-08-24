-- local home = os.getenv("HOME")
-- local dap = require("dap")
-- dap.adapters.node2 = {
--         type = "executable",
--         command = "node",
--         -- args = { home .. "/personal/microsoft-sucks/vscode-node-debug2/out/src/nodeDebug.js" },
-- }
local DEBUGGER_PATH = vim.fn.stdpath "data" .. "/site/pack/packer/opt/vscode-js-debug"
require("dap-vscode-js").setup({
    node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
    debugger_path = DEBUGGER_PATH,
    -- debugger_cmd = { "extension" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    adapters = { 'chrome', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost', 'node', 'chrome' }, -- which adapters to register in nvim-dap
    -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
    -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
    -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})
require("nvim-dap-virtual-text").setup()
require("dapui").setup({})

local dap, dapui = require("dap"), require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open({})
end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--     dapui.close({})
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--     dapui.close({})
-- end

local js_based_languages = { "typescript", "javascript", "typescriptreact" }


for _, language in ipairs(js_based_languages) do
    require("dap").configurations[language] = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require 'dap.utils'.pick_process,
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-chrome",
            request = "launch",
            name = "Start Chrome with \"localhost\"",
            url = "https://localhost:8080",
            webRoot = "${workspaceFolder}",
            userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
                "./node_modules/jest/bin/jest.js",
                "--runInBand",
            },
            -- rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
        },
        {
            name = "Debug Jest Tests NEW",
            type = "pwa-node",
            request = "launch",
            runtimeExecutable = "node",
            trace = true,
            runtimeArgs = {
                "./node_modules/jest/bin/jest.js",
                "--runInBand",
                "-r esm",
            },
            -- args = { "--inspect", "${file}", },
            -- port = 9229,
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen"
        },
        {
            name = "ts-node (Node2 with ts-node)",
            type = "pwa-node",
            request = "launch",
            cwd = vim.loop.cwd(),
            runtimeArgs = { "-r", "ts-node/register" },
            runtimeExecutable = "node",
            args = { "--inspect", "${file}" },
            trace = true,
            sourceMaps = true,
            -- skipFiles = { "<node_internals>/**", "node_modules/**" },
            resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**"
            },
        },
        {
            name = "Jest (Node2 with ts-node)",
            type = "pwa-node",
            request = "launch",
            cwd = vim.loop.cwd(),
            runtimeArgs = { "./node_modules/jest/bin/jest.js" },
            runtimeExecutable = "node",
            args = { "${file}", "--runInBand", "--coverage", "false" },
            trace = true,
            sourceMaps = true,
            port = 9229,
            resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**"
            },
            skipFiles = {
                "<node_internals>/**",
                "node_modules/**",
            },
        },
    }
end
