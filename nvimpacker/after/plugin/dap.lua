local dap = require("dap")
-- Set keymaps to control the debugger
vim.keymap.set('n', '<leader>da', require 'dap'.continue)
vim.keymap.set('n', '<leader>o', require 'dap'.step_over)
vim.keymap.set('n', '<leader>i', require 'dap'.step_into)
vim.keymap.set('n', '<leader>t', require 'dap'.step_out)
vim.keymap.set('n', '<leader>b', require 'dap'.toggle_breakpoint)
vim.keymap.set('n', '<leader>B', function()
    require 'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end)

vim.keymap.set('n', '<leader>ui', function() require 'dapui'.toggle({ reset = true }) end)
vim.keymap.set('n', '<leader>ev', function() require 'dapui'.eval() end)
vim.keymap.set('n', '<leader>aw', require 'dapui'.elements.watches.add)
