-- lua/config/plugins/luasnip.lua
return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets", -- Pre-made snippets
  },
  config = function()
    local luasnip = require("luasnip")
    local s = luasnip.snippet
    local t = luasnip.text_node
    local i = luasnip.insert_node

    require("luasnip.loaders.from_vscode").lazy_load()

    local snippets = {
      -- Regular arrow function
      s("aarf", {
        t("const "), i(1, "functionName"), t(" = ("), i(2, "params"), t("): "),
        i(3, "ReturnType"), t(" => {"),
        t({ "", "  " }), i(4, "// code"),
        t({ "", "};" }),
      }),

      -- Async arrow function
      s("aaf", {
        t("const "), i(1, "functionName"), t(" = async ("), i(2, "params"),
        t(": "), i(3, "type"), t("): Promise<"), i(4, "ReturnType"), t("> => {"),
        t({ "", "  " }), i(5, "// code"),
        t({ "", "};" }),
      }),
    }

    luasnip.add_snippets("typescript", snippets)
    luasnip.add_snippets("typescriptreact", snippets)
    luasnip.add_snippets("javascript", snippets)
    luasnip.add_snippets("javascriptreact", snippets)
  end,
}
