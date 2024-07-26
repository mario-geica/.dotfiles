require("dap-vscode-js").setup({
    node_path = "node",
  debugger_path = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter',
  debugger_cmd = { 'js-debug-adapter' },
  adapters = { 'chrome', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost', 'node', 'chrome' }, -- which adapters to register in nvim-dap
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
            -- request = "launch",
            request = "attach",
            name = "Debug Jest Tests",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
                "./node_modules/jest/bin/jest.js",
                "--runInBand",
            },
            -- port = 35355,
            -- rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest File",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
                "./node_modules/jest/bin/jest.js",
                "--runInBand",
                "${file}"
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
            -- port = 8123,
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
