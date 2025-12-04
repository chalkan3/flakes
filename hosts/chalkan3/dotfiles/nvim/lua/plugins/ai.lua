return {
    -- Copilot Chat - Chat com GitHub Copilot
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        dependencies = {
            { "zbirenbaum/copilot.lua" },
            { "nvim-lua/plenary.nvim" },
        },
        cmd = { "CopilotChat", "CopilotChatExplain", "CopilotChatReview", "CopilotChatFix" },
        config = function()
            require("CopilotChat").setup({
                debug = false,
            })

            -- Keymaps para Copilot Chat
            vim.keymap.set("n", "<leader>cp", ":CopilotChat ", { desc = "Copilot Chat" })
            vim.keymap.set("v", "<leader>ce", ":CopilotChatExplain<CR>", { desc = "Copilot Explain" })
            vim.keymap.set("v", "<leader>cr", ":CopilotChatReview<CR>", { desc = "Copilot Review" })
            vim.keymap.set("v", "<leader>cf", ":CopilotChatFix<CR>", { desc = "Copilot Fix" })
        end,
    },

    -- Copilot.lua - Versão Lua do Copilot (mais performática)
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<Tab>",
                        accept_word = "<C-l>",
                        accept_line = "<C-j>",
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = "<C-]>",
                    },
                },
                panel = {
                    enabled = true,
                    auto_refresh = true,
                    keymap = {
                        jump_prev = "[[",
                        jump_next = "]]",
                        accept = "<CR>",
                        refresh = "gr",
                        open = "<M-CR>",
                    },
                },
                filetypes = {
                    yaml = false,
                    markdown = false,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    hgcommit = false,
                    svn = false,
                    cvs = false,
                    ["."] = false,
                },
            })
        end,
    },

    -- Avante.nvim - Claude AI assistant estilo Cursor IDE
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        build = "make",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        opts = {
            provider = "claude",
            claude = {
                endpoint = "https://api.anthropic.com",
                model = "claude-sonnet-4-5-20250929",
                temperature = 0,
                max_tokens = 4096,
            },
            behaviour = {
                auto_suggestions = false,
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = false,
                support_paste_from_clipboard = false,
            },
            mappings = {
                ask = "<leader>aa",
                edit = "<leader>ae",
                refresh = "<leader>ar",
                diff = {
                    ours = "co",
                    theirs = "ct",
                    none = "c0",
                    both = "cb",
                    next = "]x",
                    prev = "[x",
                },
                jump = {
                    next = "]]",
                    prev = "[[",
                },
                submit = {
                    normal = "<CR>",
                    insert = "<C-s>",
                },
                toggle = {
                    debug = "<leader>ad",
                    hint = "<leader>ah",
                },
            },
            hints = {
                enabled = true,
            },
            windows = {
                wrap = true,
                width = 30,
                sidebar_header = {
                    align = "center",
                    rounded = true,
                },
            },
            highlights = {
                diff = {
                    current = "DiffText",
                    incoming = "DiffAdd",
                },
            },
        },
        keys = {
            { "<leader>aa", mode = { "n", "v" }, desc = "Avante Ask" },
            { "<leader>ae", mode = { "n", "v" }, desc = "Avante Edit" },
            { "<leader>ar", mode = "n", desc = "Avante Refresh" },
            { "<leader>at", "<cmd>AvanteToggle<cr>", desc = "Avante Toggle" },
        },
    },
}
