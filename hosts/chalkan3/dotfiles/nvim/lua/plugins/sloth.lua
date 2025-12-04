-- ═══════════════════════════════════════════════════════════════════════
-- 🦥 Sloth Runner DSL Plugin
-- ═══════════════════════════════════════════════════════════════════════

return {
	{
		"chalkan3-sloth/sloth-runner",
		ft = "sloth",
		dir = vim.fn.expand("~/.projects/task-runner/nvim-plugin"), -- Local development
		-- Uncomment to use from GitHub:
		-- Remove or comment the 'dir' line above, then uncomment below:
		-- "chalkan3-sloth/sloth-runner",
		-- subdir = "nvim-plugin",
		dependencies = {
			"hrsh7th/nvim-cmp", -- Optional: for completion
			"nvim-telescope/telescope.nvim", -- Optional: for pickers
			"folke/which-key.nvim", -- Optional: for keymap hints
		},
		config = function()
			require("sloth-runner").setup({
				-- Runner configuration
				runner = {
					cmd = "sloth-runner", -- Path to sloth-runner executable
					use_float = true, -- Use floating window for output
					notify = true, -- Show notifications
				},

				-- Formatter configuration
				formatter = {
					format_on_save = false, -- Auto-format on save
					cmd = "stylua", -- External formatter
					use_builtin = true, -- Fallback to built-in formatter
				},

				-- Completion configuration
				completion = {
					enabled = true, -- Enable nvim-cmp integration
					show_docs = true, -- Show documentation in completion
				},

				-- Keymap configuration
				keymaps = {
					enabled = true, -- Enable default keymaps
					prefix = "<leader>s", -- Keymap prefix
					run = "r", -- Run workflow
					list = "l", -- List tasks
					test = "t", -- Dry run
					validate = "v", -- Validate file
					format = "f", -- Format file
				},

				-- Telescope integration
				telescope = {
					enabled = true, -- Enable telescope integration
					theme = "dropdown", -- Picker theme
				},

				-- UI configuration
				ui = {
					icons = {
						task = "📋",
						workflow = "🔄",
						running = "⚡",
						success = "✓",
						error = "✗",
					},
					-- Welcome banner
					show_welcome = true, -- Show 🦥 when opening .sloth files
					welcome_style = "notification", -- "notification", "banner", "large", "float"
				},
			})
		end,
	},
}
