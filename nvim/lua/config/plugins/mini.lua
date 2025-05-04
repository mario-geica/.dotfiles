-- lua/custom/plugins/mini.lua
return {
  {
    'echasnovski/mini.nvim',
    enabled = true,
    config = function()
      local statusline = require('mini.statusline')
      statusline.setup({
        use_icons = true,
      })
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = { text = '+' },
          change       = { text = '~' },
          delete       = { text = '-' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        current_line_blame = true,   -- Toggle inline blame information
        current_line_blame_opts = {
          virt_text = true,          -- Show blame as virtual text
          virt_text_pos = 'eol',     -- Position at end of line
          delay = 300,               -- Delay in milliseconds
          ignore_whitespace = false, -- Ignore whitespace changes
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>'
      })
    end
  }
}
