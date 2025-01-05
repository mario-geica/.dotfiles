return {
  "hrsh7th/nvim-cmp",
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      snippet = {
        expand = function(args)
          print("Expanding snippet with body:", args.body)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-b>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-Space>'] = cmp.mapping.complete(),

        -- Tab key mapping for snippet navigation
        ['<C-j>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable() then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<C-k>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
    })
  end,
  dependencies = {
    "L3MON4D3/LuaSnip",             -- Snippet engine
    "rafamadriz/friendly-snippets", -- Pre-made snippets
    "saadparwaiz1/cmp_luasnip",     -- LuaSnip source for nvim-cmp
    "hrsh7th/cmp-nvim-lsp",         -- LSP source for nvim-cmp
    "hrsh7th/cmp-buffer",           -- Buffer source for nvim-cmp
    "hrsh7th/cmp-path",             -- Path source for nvim-cmp
  },
}
