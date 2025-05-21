return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",
          "lua_ls",
          "html",
          "cssls",
          "ts_ls"
        },
        automatic_installation = true,
        handlers = {
          -- Default handler for all servers
          function(server_name)
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,
          -- Override for clangd - skip it here since we set it up manually
          ["clangd"] = function() end,
        }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●', -- The icon before the error message
          spacing = 4, -- Space between your code and the error text
          -- severity = vim.diagnostic.severity.WARN,  -- Uncomment to only show warnings and errors
        }, -- This enables inline errors
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
      -- Use default capabilities (blink.cmp doesn't need special setup)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local lspconfig = require("lspconfig")

      -- Your keymaps
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

      -- LspAttach autocommand
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<space>fc', function()
            print("Formatting")
            vim.lsp.buf.format { async = true }
          end, opts)
          -- Auto-trigger signature help when typing (
          vim.keymap.set('i', '(', function()
            vim.fn.feedkeys('(', 'n') -- Insert the ( character
            vim.defer_fn(function()   -- Small delay to let LSP catch up
              vim.lsp.buf.signature_help()
            end, 50)
          end, opts)
        end,
      })

      -- Simple server setup - avoiding setup_handlers
      -- local servers = { "clangd", "lua_ls", "html", "cssls", "ts_ls" }
      -- for _, server_name in ipairs(servers) do
      --   lspconfig[server_name].setup({
      --     capabilities = capabilities,
      --   })
      -- end

      -- Special config for clangd if needed
      lspconfig.clangd.setup({
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
          "--query-driver=/usr/bin/*,/usr/local/bin/*",
        },
      })
    end,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      -- Removed cmp-nvim-lsp since we're using blink
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    }
  },
}
