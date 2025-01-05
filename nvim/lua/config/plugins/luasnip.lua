-- lua/config/plugins/luasnip.lua
return {
  "L3MON4D3/LuaSnip",
  config = function()
    local luasnip = require("luasnip")

    -- Debug: Check if luasnip is loaded
    print("LuaSnip loaded:", luasnip ~= nil)

    -- Load friendly-snippets
    print("Loading friendly-snippets...")
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Debug: Check if snippets are loaded
    vim.schedule(function()
      print("Snippets loaded for filetype:", vim.bo.filetype)
      if luasnip.snippets then
        for ft, snippets in pairs(luasnip.snippets) do
          print("Filetype:", ft)
          for trigger, _ in pairs(snippets) do
            print("  Snippet trigger:", trigger)
          end
        end
      else
        print("No snippets loaded for filetype:", vim.bo.filetype)
      end
    end)
  end,
  dependencies = {
    "rafamadriz/friendly-snippets", -- Pre-made snippets
  },
}
