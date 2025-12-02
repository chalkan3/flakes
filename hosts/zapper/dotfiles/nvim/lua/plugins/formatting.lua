return {
    -- Conform - Formatação de código moderna e rápida
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>fm",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = { "n", "v" },
                desc = "Format buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                javascript = { { "prettierd", "prettier" } },
                typescript = { { "prettierd", "prettier" } },
                javascriptreact = { { "prettierd", "prettier" } },
                typescriptreact = { { "prettierd", "prettier" } },
                json = { "jq" },
                yaml = { "yamlfmt" },
                html = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                markdown = { "prettier" },
                go = { "gofmt", "goimports" },
                rust = { "rustfmt" },
                ruby = { "rubocop" },
                sh = { "shfmt" },
                toml = { "taplo" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        },
    },

    -- Nvim Lint - Linting assíncrono
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescriptreact = { "eslint_d" },
                python = { "pylint" },
                markdown = { "markdownlint" },
                dockerfile = { "hadolint" },
                yaml = { "yamllint" },
                json = { "jsonlint" },
            }

            -- Auto-lint ao salvar
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },

    -- Better code action menu
    {
        "weilbith/nvim-code-action-menu",
        cmd = "CodeActionMenu",
        keys = {
            { "<leader>ca", ":CodeActionMenu<CR>", desc = "Code Action Menu" },
        },
    },

    -- Refactoring tools
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        keys = {
            { "<leader>re", ":Refactor extract ", mode = "x", desc = "Extract Function" },
            { "<leader>rf", ":Refactor extract_to_file ", mode = "x", desc = "Extract to File" },
            { "<leader>rv", ":Refactor extract_var ", mode = "x", desc = "Extract Variable" },
            { "<leader>ri", ":Refactor inline_var", mode = { "n", "x" }, desc = "Inline Variable" },
            { "<leader>rI", ":Refactor inline_func", desc = "Inline Function" },
            { "<leader>rb", ":Refactor extract_block", desc = "Extract Block" },
            { "<leader>rbf", ":Refactor extract_block_to_file", desc = "Extract Block to File" },
        },
        config = function()
            require("refactoring").setup()
        end,
    },

    -- Multiple cursors
    {
        "mg979/vim-visual-multi",
        branch = "master",
        event = "VeryLazy",
    },

    -- Better quickfix
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        opts = {},
    },

    -- Text case conversion
    {
        "johmsalas/text-case.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("textcase").setup()
            require("telescope").load_extension("textcase")

            vim.keymap.set("n", "<leader>tc", ":TextCaseOpenTelescope<CR>", { desc = "Text Case" })
        end,
    },

    -- Better increment/decrement
    {
        "monaqa/dial.nvim",
        keys = {
            { "<C-a>", function() require("dial.map").inc_normal() end, desc = "Increment" },
            { "<C-x>", function() require("dial.map").dec_normal() end, desc = "Decrement" },
            { "g<C-a>", function() require("dial.map").inc_gnormal() end, desc = "Increment" },
            { "g<C-x>", function() require("dial.map").dec_gnormal() end, desc = "Decrement" },
            { "<C-a>", mode = "v", function() require("dial.map").inc_visual() end, desc = "Increment" },
            { "<C-x>", mode = "v", function() require("dial.map").dec_visual() end, desc = "Decrement" },
            { "g<C-a>", mode = "v", function() require("dial.map").inc_gvisual() end, desc = "Increment" },
            { "g<C-x>", mode = "v", function() require("dial.map").dec_gvisual() end, desc = "Decrement" },
        },
    },
}
