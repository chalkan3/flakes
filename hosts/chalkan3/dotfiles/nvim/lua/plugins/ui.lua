return {
    -- 🎨 Tema de Cores Principal
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "night", -- night, storm, moon, day
            transparent = true, -- Fundo transparente
            terminal_colors = true,
            styles = {
                comments = { italic = true },
                keywords = { italic = true },
                functions = { bold = true },
                variables = {},
                sidebars = "transparent", -- Sidebars transparentes
                floats = "transparent", -- Janelas flutuantes transparentes
            },
            sidebars = { "qf", "help", "terminal", "packer" },
            dim_inactive = false,
            lualine_bold = true,
            on_colors = function(colors)
                colors.border = "#7aa2f7"
            end,
            on_highlights = function(hl, c)
                hl.CursorLineNr = { fg = c.orange, bold = true }
                hl.LineNr = { fg = c.dark5 }
                hl.FloatBorder = { fg = c.border, bg = c.none }
            end,
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            vim.cmd("colorscheme tokyonight-night")
        end
    },
    "nvim-tree/nvim-web-devicons",

    -- Icons
    {
        "echasnovski/mini.icons",
        config = function()
            require("mini.icons").setup()
        end,
    },

    -- 🚥 Status Line (Rodapé)
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "auto",
                component_separators = { left = "|", right = "|" },
                section_separators = { left = "", right = "" },
                globalstatus = true,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff" },
                lualine_c = {
                    {
                        "filename",
                        path = 1,
                        symbols = {
                            modified = " ●",
                            readonly = " ",
                            unnamed = "[No Name]",
                        },
                    },
                },
                lualine_x = {
                    {
                        "diagnostics",
                        sources = { "nvim_lsp" },
                        symbols = { error = " ", warn = " ", info = " ", hint = " " },
                    },
                    "encoding",
                    "fileformat",
                    "filetype",
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            extensions = { "nvim-tree", "toggleterm", "trouble" },
        },
    },

    -- 🌳 Explorador de Arquivos
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        cmd = "NvimTreeToggle",
        opts = {
            view = {
                width = 30,
            },
            renderer = {
                group_empty = true,
                icons = {
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                    },
                },
            },
            actions = {
                open_file = {
                    quit_on_open = true,
                },
            },
            filters = {
                dotfiles = false,
            },
        },
    },

    -- 💅 Melhora as Janelas e Prompts (Substitui prompts feios por flutuantes)
    {
        "stevearc/dressing.nvim",
        opts = {},
    },

    -- 📑 Abas/Buffers aprimorado
    {
        "akinsho/bufferline.nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                mode = "buffers",
                themable = true,
                numbers = "none",
                close_command = "bdelete! %d",
                right_mouse_command = "bdelete! %d",
                left_mouse_command = "buffer %d",
                indicator = {
                    style = 'icon',
                    icon = '▎',
                },
                buffer_close_icon = '',
                modified_icon = '●',
                close_icon = '',
                left_trunc_marker = '',
                right_trunc_marker = '',
                diagnostics = "nvim_lsp",
                diagnostics_update_in_insert = false,
                diagnostics_indicator = function(count, level)
                    local icon = level:match("error") and " " or " "
                    return " " .. icon .. count
                end,
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "📁 File Explorer",
                        text_align = "center",
                        separator = true,
                    }
                },
                color_icons = true,
                show_buffer_icons = true,
                show_buffer_close_icons = true,
                show_close_icon = false,
                show_tab_indicators = true,
                separator_style = "thin",
                enforce_regular_tabs = false,
                always_show_bufferline = true,
                sort_by = 'insert_after_current',
            },
            highlights = {
                buffer_selected = {
                    bold = true,
                    italic = false,
                },
            }
        }
    },

    -- 📏 Guias de Indentação Visíveis com Cores
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "BufReadPost",
        opts = {
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = {
                enabled = true,
                show_start = true,
                show_end = false,
                injected_languages = true,
                highlight = {
                    "RainbowDelimiterRed",
                    "RainbowDelimiterYellow",
                    "RainbowDelimiterBlue",
                    "RainbowDelimiterOrange",
                    "RainbowDelimiterGreen",
                    "RainbowDelimiterViolet",
                    "RainbowDelimiterCyan",
                },
                priority = 500,
            },
            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
            },
        },
        config = function(_, opts)
            -- Define cores do arco-íris
            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#E06C75" })
                vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#E5C07B" })
                vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#D19A66" })
                vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#98C379" })
                vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#C678DD" })
                vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#56B6C2" })
            end)
            require("ibl").setup(opts)
        end,
    },

    -- ✨ Notificações Modernas (Substitui as mensagens padrão do vim)
    {
        "rcarriga/nvim-notify",
        opts = {
            timeout = 3000,
            max_width = 50,
            max_height = 10,
            stages = "fade_in_slide_out",
            background_colour = "#000000",
            top_down = false,
            render = "compact",
            icons = {
                ERROR = "",
                WARN = "",
                INFO = "",
                DEBUG = "",
                TRACE = "✎",
            },
        },
        config = function(_, opts)
            require("notify").setup(opts)
            vim.notify = require("notify")
        end,
    },

    -- 🔔 Substitui Linha de Comando e Mensagens Flutuantes
    {
        "folke/noice.nvim",
        lazy = false,
        cond = not vim.g.vscode and vim.fn.has("gui_running") == 0 and os.getenv("TERM") ~= nil,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            views = {
                cmdline_popup = {
                    size = {
                        width = 60,
                        height = 5,
                    },
                },
            },
            messages = {
                -- Substitui 'Press ENTER or type command to continue'
                view = "mini",
            },
        },
    },


    -- ⌨️  Which-Key
    {
        "folke/which-key.nvim",
        lazy = false,
        config = function()
            require("which-key").setup()
        end,
    },

    -- Terminal integrado
    {
        "akinsho/toggleterm.nvim",
        cmd = "ToggleTerm",
        config = function()
            require("toggleterm").setup()
        end,
    },

    -- Startup screen
    {
        "goolord/alpha-nvim",
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            -- ASCII Art
            dashboard.section.header.val = {
                "                                                       ",
                "   ██████╗██╗  ██╗ █████╗ ██╗     ██╗  ██╗ █████╗ ███╗   ██╗██████╗ ",
                "  ██╔════╝██║  ██║██╔══██╗██║     ██║ ██╔╝██╔══██╗████╗  ██║╚════██╗",
                "  ██║     ███████║███████║██║     █████╔╝ ███████║██╔██╗ ██║ █████╔╝",
                "  ██║     ██╔══██║██╔══██║██║     ██╔═██╗ ██╔══██║██║╚██╗██║ ╚═══██╗",
                "  ╚██████╗██║  ██║██║  ██║███████╗██║  ██╗██║  ██║██║ ╚████║██████╔╝",
                "   ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ",
                "                                                       ",
            }

            -- Botões
            dashboard.section.buttons.val = {
                dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
                dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
                dashboard.button("g", "  Find text", ":Telescope live_grep <CR>"),
                dashboard.button("c", "  Config", ":e ~/.config/nvim/init.lua <CR>"),
                dashboard.button("p", "  Projects", ":Telescope project <CR>"),
                dashboard.button("q", "  Quit", ":qa<CR>"),
            }

            -- Footer
            local function footer()
                local total_plugins = #vim.tbl_keys(require("lazy").plugins())
                local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
                local version = vim.version()
                local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

                return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
            end

            dashboard.section.footer.val = footer()

            dashboard.section.footer.opts.hl = "Type"
            dashboard.section.header.opts.hl = "Include"
            dashboard.section.buttons.opts.hl = "Keyword"

            dashboard.opts.opts.noautocmd = true
            alpha.setup(dashboard.opts)
        end,
    },

    -- Smooth scrolling
    {
        "karb94/neoscroll.nvim",
        config = function()
            require("neoscroll").setup()
        end,
    },

    -- Symbol outline
    {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        config = function()
            require("symbols-outline").setup()
        end,
    },

    -- Better diagnostics
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "TroubleToggle",
        config = function()
            require("trouble").setup()
        end,
    },

    -- Vim Illuminate - Destaca palavra sob cursor
    {
        "RRethy/vim-illuminate",
        event = "BufReadPost",
        config = function()
            require("illuminate").configure({
                providers = {
                    "lsp",
                    "treesitter",
                    "regex",
                },
                delay = 100,
                under_cursor = true,
            })
        end,
    },

    -- Mini.indentscope - Visualização de escopo
    {
        "echasnovski/mini.indentscope",
        event = "BufReadPost",
        opts = {
            symbol = "│",
            options = { try_as_border = true },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },

    -- 📜 Scrollbar visual
    {
        "petertriho/nvim-scrollbar",
        event = "BufReadPost",
        opts = {
            show = true,
            handle = {
                color = "#7aa2f7",
            },
            marks = {
                Search = { color = "#ff9e64" },
                Error = { color = "#f7768e" },
                Warn = { color = "#e0af68" },
                Info = { color = "#7dcfff" },
                Hint = { color = "#1abc9c" },
                Misc = { color = "#bb9af7" },
            },
            handlers = {
                gitsigns = true,
                search = true,
            },
        },
    },

    -- 🎨 Highlight de cores aprimorado (substitui colorizer)
    {
        "brenoprata10/nvim-highlight-colors",
        event = "BufReadPost",
        opts = {
            render = "background", -- 'background', 'foreground', 'virtual'
            enable_named_colors = true,
            enable_tailwind = true,
        },
    },

    -- 🧘 Zen Mode - Foco total
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        keys = {
            { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" }
        },
        opts = {
            window = {
                width = 120,
                options = {
                    number = false,
                    relativenumber = false,
                    signcolumn = "no",
                    cursorline = false,
                }
            },
            plugins = {
                gitsigns = { enabled = false },
                tmux = { enabled = false },
                kitty = {
                    enabled = true,
                    font = "+4",
                },
            },
        },
    },

    -- 🎨 Color Picker Interativo
    {
        "uga-rosa/ccc.nvim",
        cmd = { "CccPick", "CccConvert", "CccHighlighterEnable" },
        keys = {
            { "<leader>cp", "<cmd>CccPick<cr>", desc = "Color Picker" },
            { "<leader>cc", "<cmd>CccConvert<cr>", desc = "Color Convert" },
        },
        opts = {
            highlighter = {
                auto_enable = true,
                lsp = true,
            },
        },
    },
}
