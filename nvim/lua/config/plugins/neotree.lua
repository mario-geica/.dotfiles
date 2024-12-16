return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            close_if_last_window = true,
            enable_git_status = true,
            enable_diagnostics = true,
            git_status = {
                symbols = {
                    added     = "+",
                    modified  = "~",
                    deleted   = "-",
                    renamed   = "→",
                    untracked = "?",
                    ignored   = "i",
                    unstaged  = "~",
                    staged    = "S",
                    conflict  = "!",
                },
                align = "right",
            },
            filesystem = {
                filtered_items = {
                    visible = false,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = true,
                },
                use_libuv_file_watcher = true,
                group_empty_dirs = true,
                scan_mode = "deep",
            },
            default_component_configs = {
                git_status = {
                    symbols = {
                        added     = "+",
                        modified  = "~",
                        deleted   = "-",
                        renamed   = "→",
                        untracked = "?",
                    },
                    align = "right",
                },
            },
            event_handlers = {
                {
                    event = "file_opened",
                    handler = function(_)
                        require("neo-tree").close_all()
                    end
                },
                {
                    event = "git_event",
                    handler = function(_)
                        require("neo-tree.command").execute({ action = "refresh" })
                    end
                },
            }
        })
    end
}
