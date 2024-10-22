return require("packer").startup(function()
	use("wbthomason/packer.nvim")
	use("joshdick/onedark.vim")
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icons
		},
		tag = "nightly", -- optional, updated every week. (see issue #1193)
	})
	use("sbdchd/neoformat")
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	-- TJ created lodash of neovim
	use("nvim-lua/plenary.nvim")
	use("nvim-lua/popup.nvim")
	use("nvim-telescope/telescope.nvim")

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- All the things
	use("neovim/nvim-lspconfig")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("onsails/lspkind-nvim")
	use("nvim-lua/lsp_extensions.nvim")
	-- use("glepnir/lspsaga.nvim")
	use("simrat39/symbols-outline.nvim")
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	use("hrsh7th/cmp-nvim-lsp-signature-help")

	use("github/copilot.vim")
	use("tpope/vim-commentary")
	use("tpope/vim-fugitive")
	use("mbbill/undotree")
	use("lewis6991/gitsigns.nvim")

	use("rafamadriz/friendly-snippets")
	-- Primeagen doesn"t create lodash
	use("ThePrimeagen/git-worktree.nvim")
	use("ThePrimeagen/harpoon")

	--use("mbbill/undotree")

	-- Colorscheme section
	use("gruvbox-community/gruvbox")
	use("folke/tokyonight.nvim")

	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("simrat39/rust-tools.nvim")
	use("rust-lang/rust.vim")

	use({
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	})
	use({
		"nvimdev/lspsaga.nvim",
		after = "nvim-lspconfig",
		config = function()
			require("lspsaga").setup({})
		end,
	})
	--use({
	--    "glepnir/lspsaga.nvim",
	--    -- opt = true,
	--    -- branch = "main",
	--    -- event = "LspAttach",
	--    config = function()
	--        require("lspsaga").setup({})
	--    end,
	--    requires = {
	--        { "nvim-tree/nvim-web-devicons" },
	--        --Please make sure you install markdown and markdown_inline parser
	--        { "nvim-treesitter/nvim-treesitter" }
	--    }
	--})
	--use("nvim-treesitter/playground")
	--use("romgrk/nvim-treesitter-context")
	-- use {
	--   "mfussenegger/nvim-dap",
	--   opt = true,
	--   module = { "dap" },
	--   requires = {
	--     "theHamsta/nvim-dap-virtual-text",
	--     "rcarriga/nvim-dap-ui",
	--     "mfussenegger/nvim-dap-python",
	--     "nvim-telescope/telescope-dap.nvim",
	--     { "leoluz/nvim-dap-go", module = "dap-go" },
	--     { "jbyuki/one-small-step-for-vimkind", module = "osv" },
	--     { "mxsdev/nvim-dap-vscode-js", module = { "dap-vscode-js" } },
	--     {
	--       "microsoft/vscode-js-debug",
	--       opt = true,
	--       run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
	--     },
	--   },
	-- config = function()
	--   require("config.dap").setup()
	-- end,
	-- disable = false,
	-- }
	use("David-Kunz/jester")
	use("mfussenegger/nvim-dap")
	use({ "mxsdev/nvim-dap-vscode-js", requires = { "mfussenegger/nvim-dap" } })
	use({
		"microsoft/vscode-js-debug",
		opt = true,
		run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
	})
	use("theHamsta/nvim-dap-virtual-text")
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
end)
