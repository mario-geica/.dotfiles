local Remap = require("mmm.keymap")
local nnoremap = Remap.nnoremap
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-x>"] = function(bufnr)
          local selection = action_state.get_selected_entry()
          actions.close(bufnr)
          if selection then
            -- Check if it's a buffer selection
            if selection.bufnr then
              vim.cmd('sbuffer ' .. selection.bufnr)
              -- If not, assume it's a file and use its path
            elseif selection.path then
              vim.cmd('split ' .. selection.path)
            else
              print("Selection does not contain a buffer number or path.")
            end
          end
        end,
        ["<C-a>"] = function(bufnr)
          local selection = action_state.get_selected_entry()
          actions.close(bufnr)
          if selection then
            if selection.bufnr then
              vim.cmd('vert sbuffer ' .. selection.bufnr)
            elseif selection.path then
              vim.cmd('vsplit ' .. selection.path)
            else
              print("Selection does not contain a buffer number or path.")
            end
          end
        end,
      },
      n = {
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
