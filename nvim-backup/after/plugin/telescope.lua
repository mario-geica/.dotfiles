local Remap = require("mmm.keymap")
local nnoremap = Remap.nnoremap
local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        -- To disable a keymap, put [map] = false
        -- So, to not map "<C-n>", just put
        -- ["<C-n>"] = false,

        -- Otherwise, just set the mapping to the function that you want it to be.
        ["<C-w>"] = actions.select_vertical,

        -- Add up multiple actions
        -- ["<cr>"] = actions.select_default + actions.center,

        -- You can perform as many actions in a row as you like
        -- ["<cr>"] = actions.select_default + actions.center + my_cool_custom_action,
      },
      n = {
        -- ["<esc>"] = actions.close,
        -- ["<C-i>"] = my_cool_custom_action,
      },
    },
  }
}
nnoremap("<C-p>", ":Telescope")
nnoremap("<leader>gs", function()
    require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ") })
end)
nnoremap("<leader>gtf", function()
    require('telescope.builtin').git_files()
end)
nnoremap("<Leader>ff", function()
    require('telescope.builtin').find_files()
end)

nnoremap("<leader>pw", function()
    require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }
end)
nnoremap("<leader>fb", function()
    require('telescope.builtin').buffers()
end)
nnoremap("<leader>vh", function()
    require('telescope.builtin').help_tags()
end)

nnoremap("<leader>gw", function()
    require('telescope').extensions.git_worktree.git_worktrees()
end)
