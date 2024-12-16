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
                    topdelete   = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked   = { text = '┆' },
                }
            })
        end
    }
}
