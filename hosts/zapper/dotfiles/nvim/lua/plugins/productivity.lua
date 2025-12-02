return {
    -- Harpoon - Navegação rápida entre arquivos importantes
    {
        "ThePrimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ha", function() require("harpoon.mark").add_file() end, desc = "Harpoon Add" },
            { "<leader>hm", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon Menu" },
            { "<leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon File 1" },
            { "<leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon File 2" },
            { "<leader>3", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon File 3" },
            { "<leader>4", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon File 4" },
        },
        config = function()
            require("harpoon").setup()
        end,
    },

    -- Todo Comments - Destaca TODO, FIXME, NOTE, etc
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = { "TodoTelescope", "TodoQuickFix", "TodoLocList" },
        event = "BufReadPost",
        config = function()
            require("todo-comments").setup()

            vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "Find Todos" })
        end,
    },

    -- Vim Fugitive - Git integration poderosa
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
        keys = {
            { "<leader>gs", ":Git<CR>", desc = "Git Status" },
            { "<leader>gd", ":Gdiffsplit<CR>", desc = "Git Diff" },
            { "<leader>gc", ":Git commit<CR>", desc = "Git Commit" },
            { "<leader>gp", ":Git push<CR>", desc = "Git Push" },
            { "<leader>gl", ":Git pull<CR>", desc = "Git Pull" },
        },
    },

    -- LazyGit integration
    {
        "kdheepak/lazygit.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "LazyGit",
        keys = {
            { "<leader>gg", ":LazyGit<CR>", desc = "LazyGit" },
        },
    },

    -- 📊 Better Git Diff View
    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff View" },
            { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
            { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
            { "<leader>gm", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Diff with Main" },
        },
        opts = {
            enhanced_diff_hl = true,
            view = {
                default = {
                    layout = "diff2_horizontal",
                },
            },
        },
    },

    -- 👤 Git Blame Inline
    {
        "f-person/git-blame.nvim",
        event = "BufReadPost",
        keys = {
            { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Git Blame Toggle" },
        },
        init = function()
            vim.g.gitblame_enabled = 0  -- desabilitado por padrão
            vim.g.gitblame_message_template = "  <author> • <date> • <summary>"
            vim.g.gitblame_date_format = "%r"
        end,
    },

    -- ⚔️  Git Conflict Resolution
    {
        "akinsho/git-conflict.nvim",
        event = "BufReadPost",
        version = "*",
        opts = {
            default_mappings = true,
            default_commands = true,
            disable_diagnostics = false,
            highlights = {
                incoming = "DiffAdd",
                current = "DiffText",
            },
        },
    },

    -- Nvim Spectre - Busca e substituição em todo o projeto
    {
        "nvim-pack/nvim-spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "Spectre",
        keys = {
            { "<leader>sr", function() require("spectre").open() end, desc = "Search & Replace" },
            { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Search Word" },
        },
        config = function()
            require("spectre").setup()
        end,
    },

    -- Session Manager - Salva e restaura sessões
    {
        "Shatur/neovim-session-manager",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "SessionManager",
        keys = {
            { "<leader>ss", ":SessionManager save_current_session<CR>", desc = "Save Session" },
            { "<leader>sl", ":SessionManager load_session<CR>", desc = "Load Session" },
        },
        config = function()
            local config = require("session_manager.config")
            require("session_manager").setup({
                autoload_mode = config.AutoloadMode.Disabled,
            })
        end,
    },

    -- Vim Sleuth - Detecta automaticamente indentação
    {
        "tpope/vim-sleuth",
        event = "BufReadPre",
    },

    -- Persistence - Salva automaticamente sessões
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {},
        keys = {
            { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
        },
    },

    -- 🧪 Testing Integration (Neotest)
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-jest",
            "nvim-neotest/neotest-go",
        },
        keys = {
            { "<leader>tt", function() require("neotest").run.run() end, desc = "Test Nearest" },
            { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test File" },
            { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Test" },
            { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test Summary" },
            { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test Output" },
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python"),
                    require("neotest-jest"),
                    require("neotest-go"),
                },
                icons = {
                    running = "",
                    passed = "",
                    failed = "",
                    skipped = "",
                },
            })
        end,
    },

    -- 📋 Better Register Preview
    {
        "tversteeg/registers.nvim",
        keys = {
            { '"',    mode = { "n", "v" } },
            { "<C-R>", mode = "i" }
        },
        opts = {
            bind_keys = {
                normal    = '"',
                visual    = '"',
                insert    = "<C-R>",
            },
        },
    },

    -- 📸 Code Screenshots
    {
        "mistricky/codesnap.nvim",
        build = "make",
        cmd = { "CodeSnap", "CodeSnapSave" },
        keys = {
            { "<leader>cs", "<cmd>CodeSnap<cr>", mode = "x", desc = "Code Snapshot" },
            { "<leader>cS", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save Code Snapshot" },
        },
        opts = {
            save_path = "~/Pictures/CodeSnaps",
            has_breadcrumbs = true,
            bg_theme = "bamboo",
            watermark = "",
        },
    },

    -- 🗄️ Database Explorer
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            "tpope/vim-dadbod",
            { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },
        },
        cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
        keys = {
            { "<leader>db", "<cmd>DBUIToggle<cr>", desc = "Database UI" },
        },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    },
}
