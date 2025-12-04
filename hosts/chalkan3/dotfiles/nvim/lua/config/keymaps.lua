local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Buffer management
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- Editing
map("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Telescope Project
map("n", "<leader>fp", "<cmd>Telescope project<cr>", { desc = "Find project" })

-- Debugging
map("n", "<leader>bpt", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle breakpoint" })
map("n", "<leader>bc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Continue" })
map("n", "<leader>bn", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Step over" })
map("n", "<leader>bs", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Step into" })
map("n", "<leader>bo", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Step out" })
map("n", "<leader>br", "<cmd>lua require'dap'.repl.toggle()<CR>", { desc = "Toggle REPL" })
map("n", "<leader>bl", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Run last" })
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })


-- WhichKey setup (deferred to ensure it loads after plugins)
vim.defer_fn(function()
    local ok, which_key = pcall(require, "which-key")
    if not ok then
        return
    end

    which_key.add({
        { "<leader>f", group = "Find" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
        { "<leader>fp", "<cmd>Telescope project<cr>", desc = "Find project" },

        { "<leader>b", group = "Debug" },
        { "<leader>bp", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "Toggle breakpoint" },
        { "<leader>bc", "<cmd>lua require'dap'.continue()<CR>", desc = "Continue" },
        { "<leader>bn", "<cmd>lua require'dap'.step_over()<CR>", desc = "Step over" },
        { "<leader>bs", "<cmd>lua require'dap'.step_into()<CR>", desc = "Step into" },
        { "<leader>bo", "<cmd>lua require'dap'.step_out()<CR>", desc = "Step out" },
        { "<leader>br", "<cmd>lua require'dap'.repl.toggle()<CR>", desc = "Toggle REPL" },
        { "<leader>bl", "<cmd>lua require'dap'.run_last()<CR>", desc = "Run last" },

        { "<leader>c", group = "Code" },
        { "<leader>ca", function() vim.lsp.buf.code_action() end, desc = "Code action" },

        { "<leader>r", group = "Rename" },
        { "<leader>rn", function() vim.lsp.buf.rename() end, desc = "Rename" },

        { "<leader>g", group = "Git" },
        { "<leader>gj", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Hunk" },
        { "<leader>gk", "<cmd>Gitsigns prev_hunk<cr>", desc = "Prev Hunk" },
        { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
        { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
        { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },

        { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
        { "<leader>E", "<cmd>NvimTreeFocus<cr>", desc = "Focus NvimTree" },
        { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
        { "<leader>o", "<cmd>SymbolsOutline<cr>", desc = "Toggle Symbols Outline" },

        { "<leader>x", group = "Trouble" },
        { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },

        { "<leader>w", ":w<CR>", desc = "Save" },
        { "<leader>q", group = "Quit" },
        { "<leader>qq", ":%d<CR>", desc = "Delete all lines" },
    })
end, 100)