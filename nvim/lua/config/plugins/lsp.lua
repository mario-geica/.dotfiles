-- Pure native LSP configuration - no nvim-lspconfig needed!
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
          "eslint",
          "ts_ls",
          "jsonls",
        },
        automatic_installation = true,
      })

      -- Configure diagnostics
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          spacing = 2,
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

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
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })

      -- Configure LSP servers using native Neovim APIs
      -- Basic servers with default configs
      vim.lsp.config('lua_ls', {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
      })

      vim.lsp.config('html', {
        cmd = { 'vscode-html-language-server', '--stdio' },
        filetypes = { 'html' },
        root_markers = { 'package.json', '.git' },
      })

      vim.lsp.config('cssls', {
        cmd = { 'vscode-css-language-server', '--stdio' },
        filetypes = { 'css', 'scss', 'less' },
        root_markers = { 'package.json', '.git' },
      })

      vim.lsp.config('eslint', {
        cmd = { 'vscode-eslint-language-server', '--stdio' },
        filetypes = {
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
          'vue',
          'svelte'
        },
        root_markers = {
          '.eslintrc.js',
          '.eslintrc.cjs',
          '.eslintrc.yaml',
          '.eslintrc.yml',
          '.eslintrc.json',
          'eslint.config.js',
          'eslint.config.mjs',
          'eslint.config.cjs',
          'package.json',
          '.git'
        },
        settings = {
          codeAction = {
            disableRuleComment = {
              enable = true,
              location = "separateLine"
            },
            showDocumentation = {
              enable = true
            }
          },
          codeActionOnSave = {
            enable = false,
            mode = "all"
          },
          experimental = {
            useFlatConfig = false
          },
          format = true,
          nodePath = "",
          onIgnoredFiles = "off",
          problems = {
            shortenToSingleLine = false
          },
          quiet = false,
          rulesCustomizations = {},
          run = "onType",
          useESLintClass = false,
          validate = "on",
          workingDirectory = {
            mode = "location"
          }
        },
        -- This is crucial for fixing the path error
        on_attach = function(client, bufnr)
          -- Ensure the working directory is set correctly
          if client.config.settings then
            client.config.settings.workingDirectory = {
              mode = "auto"
            }
          end
        end
      })

      vim.lsp.config('ts_ls', {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
      })

      vim.lsp.config('jsonls', {
        cmd = { 'vscode-json-language-server', '--stdio' },
        filetypes = { 'json', 'jsonc' },
        root_markers = { 'package.json', '.git' },
        settings = {
          json = {
            schemas = {},
            validate = { enable = true },
            format = {
              enable = true,
              keepLines = false
            }
          }
        }
      })

      vim.lsp.config('clangd', {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
          "--query-driver=/usr/bin/*,/usr/local/bin/*",
        },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
        root_markers = {
          'Makefile',
          'configure.in',
          'configure.ac',
          '.git',
          'compile_commands.json',
          'compile_flags.txt'
        },
      })

      -- Enable all servers
      vim.lsp.enable({
        'clangd',
        'lua_ls',
        'html',
        'cssls',
        'eslint',
        'ts_ls',
        'jsonls'
      })
    end,
    dependencies = {
      "williamboman/mason.nvim",
    }
  },
}
