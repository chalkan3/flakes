return {
    {
        "folke/lazydev.nvim",
        opts = {},
    },

    {
        "williamboman/mason.nvim",
        opts = {
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        },
    },

    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
            "williamboman/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local mason_lspconfig = require("mason-lspconfig")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")

            local on_attach = function(client, bufnr)
                local opts = { noremap = true, silent = true }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
            end

            mason_lspconfig.setup({
                handlers = {
                    function(server_name)
                        lspconfig[server_name].setup({
                            on_attach = on_attach,
                            capabilities = cmp_nvim_lsp.default_capabilities(),
                        })
                    end,

                    lua_ls = function()
                        lspconfig.lua_ls.setup({
                            on_attach = on_attach,
                            capabilities = cmp_nvim_lsp.default_capabilities(),
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { "vim" },
                                    },
                                    workspace = {
                                        library = {
                                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                            [vim.fn.stdpath("config") .. "/lua"] = true,
                                        },
                                    },
                                },
                            },
                        })
                    end,
                },
            })
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-calc",
            "onsails/lspkind.nvim",
        },
        opts = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            return {
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                experimental = {
                    ghost_text = {
                        hl_group = "Comment",
                    },
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "...",
                    }),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp", priority = 1000 },
                    { name = "luasnip", priority = 900 },
                    { name = "nvim_lua", priority = 800 },
                    { name = "buffer", priority = 700 },
                    { name = "path", priority = 600 },
                    { name = "nvim_lsp_signature_help", priority = 500 },
                    { name = "calc", priority = 400 },
                }),
            }
        end
    },

    "nvim-treesitter/nvim-treesitter-textobjects",

    -- Git integration com visual aprimorado
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPost",
        opts = {
            signs = {
                add          = { text = '│' },
                change       = { text = '│' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
            },
            signcolumn = true,
            numhl      = false,
            linehl     = false,
            word_diff  = false,
            watch_gitdir = {
                follow_files = true
            },
            attach_to_untracked = true,
            current_line_blame = false,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol',
                delay = 1000,
                ignore_whitespace = false,
            },
            current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil,
            max_file_length = 40000,
            preview_config = {
                border = 'rounded',
                style = 'minimal',
                relative = 'cursor',
                row = 0,
                col = 1
            },
        },
    },

    -- Auto-closing pairs
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },

    -- Surrounding text
    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup()
        end,
    },

    -- Code formatting

    -- Debugging
    {
        "mfussenegger/nvim-dap",
        config = function()
            require("dap").setup()
        end,
    },

    -- Mason LSP Config
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                "lua_ls",
                "ts_ls",  -- TypeScript/JavaScript
                "pyright", -- Python
                "rust_analyzer", -- Rust
                "gopls", -- Go
                "clangd", -- C/C++
                "bashls", -- Bash
                "jsonls", -- JSON
                "yamlls", -- YAML
                "html", -- HTML
                "cssls", -- CSS
            },
            automatic_installation = true,
        },
    },

    -- 💡 LSP UI Avançado
    {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            ui = {
                border = "rounded",
                code_action = "",
            },
            lightbulb = {
                enable = false,  -- usando nvim-lightbulb separado
            },
            symbol_in_winbar = {
                enable = true,  -- breadcrumbs no topo
            },
            code_action = {
                num_shortcut = true,
                show_server_name = true,
                keys = {
                    quit = "q",
                    exec = "<CR>",
                },
            },
            diagnostic = {
                border_follow = true,
                diagnostic_only_current = false,
            },
            finder = {
                keys = {
                    edit = "<CR>",
                    vsplit = "v",
                    split = "s",
                    quit = "q",
                },
            },
        },
        keys = {
            { "gd", "<cmd>Lspsaga goto_definition<cr>", desc = "Goto Definition" },
            { "gp", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition" },
            { "gr", "<cmd>Lspsaga finder<cr>", desc = "LSP Finder" },
            { "<leader>ca", "<cmd>Lspsaga code_action<cr>", desc = "Code Action" },
            { "<leader>rn", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
            { "<leader>pd", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition" },
            { "<leader>ld", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Line Diagnostics" },
            { "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Prev Diagnostic" },
            { "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Next Diagnostic" },
            { "K", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover Doc" },
            { "<leader>o", "<cmd>Lspsaga outline<cr>", desc = "Outline" },
        },
    },

    -- 💡 Lightbulb para Code Actions
    {
        "kosayoda/nvim-lightbulb",
        event = "LspAttach",
        opts = {
            sign = {
                enabled = true,
                text = "",
                hl = "DiagnosticSignInfo",
            },
            virtual_text = {
                enabled = false,
            },
            autocmd = {
                enabled = true,
            },
        },
    },
}