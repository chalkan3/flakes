return {
    -- ⚡ Performance - Cache de módulos Lua
    {
        "lewis6991/impatient.nvim",
        config = function()
            require("impatient")
        end
    },

    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-project.nvim" },
        cmd = "Telescope",
        opts = {
            defaults = {
                prompt_prefix = "🔍 ",
                selection_caret = "➜ ",
                path_display = { "truncate" },
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        results_width = 0.8,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                border = {},
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                color_devicons = true,
                set_env = { ["COLORTERM"] = "truecolor" },
                file_ignore_patterns = { "node_modules", ".git/" },
            },
            pickers = {
                find_files = {
                    hidden = true,
                },
                live_grep = {
                    additional_args = function()
                        return { "--hidden" }
                    end,
                },
            },
            extensions = {
                project = {
                    base_dirs = { "~/projects", "~/work" },
                },
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        main = "nvim-treesitter.configs",
        opts = {
            ensure_installed = {
                -- Web
                "html", "css", "scss", "javascript", "typescript", "tsx", "json",
                -- Systems
                "lua", "vim", "vimdoc", "bash", "c", "cpp", "rust", "go",
                -- Scripting
                "python", "ruby", "php",
                -- Data
                "yaml", "toml",
                -- Others
                "markdown", "markdown_inline", "regex", "dockerfile", "gitignore",
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    scope_incremental = "<S-CR>",
                    node_decremental = "<BS>",
                },
            },
            -- Auto-install parsers when entering buffer
            auto_install = true,
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end
    },

    "nvim-treesitter/nvim-treesitter-context",

    {
        "numToStr/Comment.nvim",
        lazy = false,
        config = function()
            require('Comment').setup()
            vim.keymap.set({ "n", "v" }, "<leader>/", function()
                require("Comment.api").toggle.linewise.current()
            end, { desc = "Comment" })
        end,
    },
}
