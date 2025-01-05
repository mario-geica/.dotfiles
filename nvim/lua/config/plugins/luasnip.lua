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
    local snippets = {
      -- Regular arrow function
      luasnip.snippet("aarf", {
        luasnip.text_node("const "),
        luasnip.insert_node(1, "functionName"),
        luasnip.text_node(" = ("),
        luasnip.insert_node(2, "params"),
        luasnip.text_node("): "),
        luasnip.insert_node(3, "ReturnType"),
        luasnip.text_node(" => {"),
        luasnip.text_node(""),   -- Empty text node for newline
        luasnip.text_node("  "), -- Indentation
        luasnip.insert_node(4, "// code"),
        luasnip.text_node(""),   -- Empty text node for newline
        luasnip.text_node("};"),
      }),

      -- Async arrow function
      luasnip.snippet("aaf", {
        luasnip.text_node("const "),
        luasnip.insert_node(1, "functionName"),
        luasnip.text_node(" = async ("),
        luasnip.insert_node(2, "params"),
        luasnip.text_node(":"),
        luasnip.insert_node(3, "type"),
        luasnip.text_node("): Promise<"),
        luasnip.insert_node(4, "ReturnType"),
        luasnip.text_node("> => {"),
        luasnip.text_node(""),   -- Empty text node for newline
        luasnip.text_node("  "), -- Indentation
        luasnip.insert_node(5, "// code"),
        luasnip.text_node(""),   -- Empty text node for newline
        luasnip.text_node("};"),
      }),
    }
    -- Register snippets for both typescript and tsx filetypes
    luasnip.add_snippets("typescript", snippets)
    luasnip.add_snippets("typescriptreact", snippets)


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
