local lspconfig = require('lspconfig')
require("mason").setup()
require("mason-lspconfig").setup()
require('mason-lspconfig').setup_handlers({
  function(server)
    lspconfig[server].setup({})
  end,
  ["tsserver"] = function()
    lspconfig.tsserver.setup({
      init_options = {
        preferences = {
          -- You can add other preferences here
          importModuleSpecifierPreference = 'relative',
          importModuleSpecifierEnding = 'minimal',
        },
      },
    })
  end,
})
