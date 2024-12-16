vim.g.theprimeagen_colorscheme = "tokyonight"
-- vim.cmd("colorscheme onedark")

function colormypencils()
    vim.g.gruvbox_contrast_dark = 'hard'
    vim.g.tokyonight_transparent_sidebar = true
    vim.g.tokyonight_transparent = true
    vim.g.gruvbox_invert_selection = '0'
    -- vim.opt.background = "dark"

    vim.cmd("colorscheme " .. vim.g.theprimeagen_colorscheme)

    local hl = function(thing, opts)
        vim.api.nvim_set_hl(0, thing, opts)
    end

    hl("signcolumn", {
        bg = "none",
    })

    hl("colorcolumn", {
        ctermbg = 0,
        bg = "#555555",
    })

    hl("cursorlinenr", {
        bg = "none"
    })

    hl("normal", {
        bg = "none"
    })

    hl("linenr", {
        fg = "#5eacd3"
    })

    hl("netrwdir", {
      fg = "#5eacd3"
    })

    -- hl("Visual", {
      -- bg = "#ede5ad" -- Setting background color to yellow
    -- })

end

colormypencils()
