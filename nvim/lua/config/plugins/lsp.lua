return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },

  -- Keep nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      local configs = require('lspconfig.configs')

      if not configs.sonarlint then
        configs.sonarlint = {
          default_config = {
            cmd = { 'sonarlint-language-server', '-stdio' },
            filetypes = { 'javascript', 'typescript', 'python', 'java', 'lua' },
            root_dir = lspconfig.util.root_pattern('.git', 'package.json', 'pom.xml'),
            settings = {},
          },
        }
      end

      -- Your diagnostic setup
      vim.diagnostic.config({
        virtual_text = { prefix = '●', spacing = 2 },
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

      -- LspAttach setup
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

          -- vtsls code actions
          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)

          vim.keymap.set('n', '<leader>dd', function()
            local diagnostics = vim.diagnostic.get(0)
            vim.cmd('new')
            vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(vim.inspect(diagnostics), '\n'))
          end, { desc = 'Show diagnostics in new buffer' })

          -- vtsls organize imports
          vim.keymap.set('n', '<space>oi', function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.organizeImports" },
                diagnostics = {},
              },
            })
          end, opts)

          -- vtsls remove unused imports
          vim.keymap.set('n', '<space>ru', function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.removeUnused" },
                diagnostics = {},
              },
            })
          end, opts)

          -- Rust-specific keymaps (only active in Rust files)
          if vim.bo[ev.buf].filetype == 'rust' then
            -- Expand macro
            vim.keymap.set('n', '<space>em', function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "rust-analyzer.expandMacro" },
                  diagnostics = {},
                },
              })
            end, { buffer = ev.buf, desc = 'Expand macro' })

            -- View HIR (High-level Intermediate Representation)
            vim.keymap.set('n', '<space>vh', function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "rust-analyzer.viewHir" },
                  diagnostics = {},
                },
              })
            end, { buffer = ev.buf, desc = 'View HIR' })

            -- Run single test
            vim.keymap.set('n', '<space>rt', function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "rust-analyzer.runSingle" },
                  diagnostics = {},
                },
              })
            end, { buffer = ev.buf, desc = 'Run single test' })
          end
        end,
      })

      -- rust-analyzer setup - Best Rust LSP
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            -- Enable all features
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Enable proc-macro support
            procMacro = {
              enable = true
            },
            -- Enable diagnostics
            diagnostics = {
              enable = true,
              experimental = {
                enable = true,
              },
            },
            -- Inlay hints
            inlayHints = {
              bindingModeHints = {
                enable = false,
              },
              chainingHints = {
                enable = true,
              },
              closingBraceHints = {
                enable = true,
                minLines = 25,
              },
              closureReturnTypeHints = {
                enable = "never",
              },
              lifetimeElisionHints = {
                enable = "never",
                useParameterNames = false,
              },
              maxLength = 25,
              parameterHints = {
                enable = true,
              },
              reborrowHints = {
                enable = "never",
              },
              renderColons = true,
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
            },
            -- Lens
            lens = {
              enable = true,
            },
            -- Hover actions
            hover = {
              actions = {
                enable = true,
              },
            },
            -- Completion
            completion = {
              callable = {
                snippets = "fill_arguments",
              },
            },
            -- Assist (refactoring)
            assist = {
              importGranularity = "module",
              importPrefix = "by_self",
            },
            -- Checkonsave (clippy)
            checkOnSave = {
              enable = true,
              command = "clippy"
            },
          }
        }
      })

      -- vtsls setup - Superior TypeScript support
      lspconfig.vtsls.setup({
        capabilities = capabilities,
        root_dir = function(fname)
          return require('lspconfig.util').root_pattern('package.json', 'serverless.yml', 'tsconfig.json',
            'jsconfig.json')(fname)
        end,
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
              autoImports = true,
            },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
            preferences = {
              importModuleSpecifier = "relative",
              importModuleSpecifierEnding = "minimal",
              includeCompletionsForModuleExports = true,
              includeCompletionsForImportStatements = true,
              includeCompletionsWithSnippetText = true,
              includeCompletionsFromNodeModules = true,
              includeSourceFromNodeModules = true,
              allowRenameOfImportPath = false,
            },
          },
          javascript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
              autoImports = true,
            },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
            preferences = {
              importModuleSpecifier = "relative",
              importModuleSpecifierEnding = "minimal",
              includeCompletionsForModuleExports = true,
              includeCompletionsForImportStatements = true,
              includeCompletionsWithSnippetText = true,
              includePackageJsonAutoImports = "on",
              includeCompletionsFromNodeModules = true,
              includeSourceFromNodeModules = true,
              allowRenameOfImportPath = false,
            },
          },
        },
      })

      lspconfig.sonarlint.setup({
        cmd = { "sonarlint-language-server", "-stdio" },
        filetypes = { "javascript", "typescript", "python", "java" },
        settings = {
          sonarlint = {
            rules = {
              ["javascript:S1481"] = "on",
              ["javascript:S4507"] = "on",
              ["javascript:S2068"] = "on",
              ["javascript:S1192"] = "on",
              ["javascript:S105"] = "on",
              ["javascript:S1854"] = "on",
              ["javascript:S3776"] = "on",
              ["javascript:S125"] = "on",
              ["typescript:S1481"] = "on",
              ["typescript:S2068"] = "on",
              ["typescript:S4507"] = "on",
            }
          }
        }
      })

      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- ESLint setup
      lspconfig.eslint.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      })
    end,
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/nvim-cmp",
    }
  },
}
