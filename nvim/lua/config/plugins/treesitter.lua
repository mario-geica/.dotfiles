-- config/plugins/treesitter.lua
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup()

      -- Idempotent: already-installed parsers are skipped.
      require('nvim-treesitter').install({
        'javascript',
        'typescript',
        'tsx',
        'html',
        'lua',
        'css',
        'markdown',
        'markdown_inline',
        'json',
        'jsonc',
        'yaml',
        'toml',
        'bash',
        'nix',
        'python',
        'diff',
        'gitcommit',
        'gitignore',
      })

      -- Enable treesitter highlighting (not automatic on the main branch)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
