local opt = vim.opt
local g = vim.g

-- ═══════════════════════════════════════════════════════════════════════
-- 🎨 UI/Visual
-- ═══════════════════════════════════════════════════════════════════════
opt.number = true                  -- Show line numbers
opt.relativenumber = true          -- Relative line numbers
opt.cursorline = true              -- Highlight current line
opt.termguicolors = true           -- Enable 24-bit RGB colors
opt.signcolumn = "yes"             -- Always show sign column (git, diagnostics)
opt.scrolloff = 8                  -- Min lines to keep above/below cursor
opt.sidescrolloff = 8              -- Min columns to keep left/right of cursor
opt.wrap = false                   -- Don't wrap lines
opt.linebreak = true               -- Wrap on word boundaries
opt.showmode = false               -- Don't show mode (lualine shows it)
opt.showcmd = true                 -- Show command in status line
opt.ruler = true                   -- Show cursor position
opt.laststatus = 3                 -- Global statusline
opt.cmdheight = 1                  -- Command line height
opt.pumheight = 10                 -- Popup menu height
opt.pumblend = 10                  -- Popup transparency
opt.winblend = 10                  -- Floating window transparency

-- ═══════════════════════════════════════════════════════════════════════
-- 📝 Editing
-- ═══════════════════════════════════════════════════════════════════════
opt.tabstop = 4                    -- Tab = 4 spaces
opt.shiftwidth = 4                 -- Indent = 4 spaces
opt.expandtab = true               -- Use spaces instead of tabs
opt.smartindent = true             -- Smart autoindenting
opt.autoindent = true              -- Copy indent from current line
opt.breakindent = true             -- Wrapped lines preserve indentation

-- ═══════════════════════════════════════════════════════════════════════
-- 🖱️  Mouse & Clipboard
-- ═══════════════════════════════════════════════════════════════════════
opt.mouse = "a"                    -- Enable mouse support
opt.clipboard = "unnamedplus"      -- Use system clipboard

-- ═══════════════════════════════════════════════════════════════════════
-- 🔍 Search
-- ═══════════════════════════════════════════════════════════════════════
opt.ignorecase = true              -- Ignore case in search
opt.smartcase = true               -- Unless uppercase is used
opt.incsearch = true               -- Incremental search
opt.hlsearch = true                -- Highlight search results
opt.gdefault = false               -- Don't use global flag by default

-- ═══════════════════════════════════════════════════════════════════════
-- 💾 Files & Backup
-- ═══════════════════════════════════════════════════════════════════════
opt.backup = false                 -- Don't create backup files
opt.writebackup = false            -- Don't create backup before writing
opt.swapfile = false               -- Don't create swap files
opt.undofile = true                -- Enable persistent undo
opt.undolevels = 10000             -- Max undo levels
opt.autowrite = true               -- Auto-save before :make, :next, etc.
opt.autoread = true                -- Auto-reload files changed outside vim

-- ═══════════════════════════════════════════════════════════════════════
-- ⚡ Performance
-- ═══════════════════════════════════════════════════════════════════════
opt.updatetime = 200               -- Faster completion (default 4000ms)
opt.timeoutlen = 300               -- Faster key sequence timeout
opt.redrawtime = 10000             -- Max time for syntax highlighting
opt.lazyredraw = false             -- Don't redraw during macros (can cause issues)

-- ═══════════════════════════════════════════════════════════════════════
-- 🪟 Windows & Splits
-- ═══════════════════════════════════════════════════════════════════════
opt.splitbelow = true              -- Horizontal splits go below
opt.splitright = true              -- Vertical splits go right
opt.splitkeep = "screen"           -- Keep text on screen when splitting

-- ═══════════════════════════════════════════════════════════════════════
-- 🔤 Completion
-- ═══════════════════════════════════════════════════════════════════════
opt.completeopt = "menu,menuone,noselect"
opt.shortmess:append("c")          -- Don't show completion messages

-- ═══════════════════════════════════════════════════════════════════════
-- 🎯 Formatting
-- ═══════════════════════════════════════════════════════════════════════
opt.formatoptions = "jcroqlnt"     -- tcqj format options

-- ═══════════════════════════════════════════════════════════════════════
-- 🌐 Misc
-- ═══════════════════════════════════════════════════════════════════════
opt.confirm = true                 -- Confirm before closing unsaved files
opt.hidden = true                  -- Allow hidden buffers
opt.virtualedit = "block"          -- Allow cursor beyond last char in visual block
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.spelllang = { "en", "pt_br" }  -- Spell check languages
opt.spellsuggest = "best,9"        -- Show 9 best suggestions
opt.inccommand = "nosplit"         -- Preview substitutions live
opt.wildmode = "longest:full,full" -- Command-line completion mode

-- ═══════════════════════════════════════════════════════════════════════
-- 🔧 Provider (disable unnecessary providers for performance)
-- ═══════════════════════════════════════════════════════════════════════
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
