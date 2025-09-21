-- In your plugins directory (e.g., ~/.config/nvim/lua/plugins/diffview.lua)
return {
  "sindrets/diffview.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, for file icons
  },
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
  },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>",        desc = "Open Diffview" },
    { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "File History" },
    { "<leader>gc", "<cmd>DiffviewClose<cr>",       desc = "Close Diffview" },
  },
  config = function()
    require("diffview").setup({
      enhanced_diff_hl = true,
      keymaps = {
        file_panel = {
          ["s"] = false,     -- Disable DiffView's 's' mapping
          ["-"] = false,     -- Disable toggle if you don't want it
          ["<C-s>"] = false, -- Disable Ctrl+S
        },
        view = {
          ["s"] = false,     -- Disable in diff view too
          ["-"] = false,     -- Disable in diff view too
          ["<C-s>"] = false, -- Disable Ctrl+S
        },
      },
      view = {
        default = {
          layout = "diff2_horizontal",
        },
      },
    })
  end,
}
