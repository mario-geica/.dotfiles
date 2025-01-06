return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
      require('telescope').setup {
        pickers = {
          find_files = {
            theme = "ivy"
          }
        },
        defaults = {
          mappings = {
            i = {
              ["<C-w>d"] = function(prompt_bufnr)
                local action_state = require('telescope.actions.state')
                local entry = action_state.get_selected_entry()
                require('telescope.actions').close(prompt_bufnr) -- Close Telescope
                vim.schedule(function()
                  vim.cmd('vsplit ' .. entry.value)              -- Open file in a vertical split
                end)
              end,
              ["<C-w>s"] = function(prompt_bufnr)
                local action_state = require('telescope.actions.state')
                local entry = action_state.get_selected_entry()
                require('telescope.actions').close(prompt_bufnr) -- Close Telescope
                vim.schedule(function()
                  vim.cmd('split ' .. entry.value)               -- Open file in a horizontal split
                end)
              end,
            },

          },
        },
        extensions = {
          fzf = {}
        }
      }

      require('telescope').load_extension('fzf')

      vim.keymap.set("n", "<leader>gs", function()
        require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ") })
      end)
      vim.keymap.set("n", "<space>fh", require('telescope.builtin').help_tags)
      vim.keymap.set("n", "<space>ff", require('telescope.builtin').find_files)

      vim.keymap.set("n", "<leader>fb", function()
        require('telescope.builtin').buffers()
      end)
      vim.keymap.set("n", "<leader>pw", function()
        require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }
      end)
      vim.keymap.set("n", "<space>en", function()
        require('telescope.builtin').find_files {
          cwd = vim.fn.stdpath("config")
        }
      end)
      vim.keymap.set("n", "<space>ep", function()
        require('telescope.builtin').find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        }
      end)

      require "config.telescope.multigrep".setup()
    end
  }
}
