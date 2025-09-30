return {
	-- Autocompletion
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			-- "milanglacier/minuet-ai.nvim",
			"fang2hou/blink-copilot",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				-- Using 'super-tab' preset for tab to accept
				preset = "super-tab",

				-- Override specific keymaps
				["<Tab>"] = {
					function(cmp)
						if vim.b[vim.api.nvim_get_current_buf()].nes_state then
							cmp.hide()
							return (
								require("copilot-lsp.nes").apply_pending_nes()
								and require("copilot-lsp.nes").walk_cursor_end_edit()
							)
						end
						if cmp.snippet_active() then
							return cmp.accept()
						else
							return cmp.select_and_accept()
						end
					end,
					"select_and_accept",
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "cancel", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
				use_nvim_cmp_as_default = false,
			},

			completion = {
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},

				list = {
					selection = {
						preselect = true,
						auto_insert = true,
					},
				},

				trigger = {
					prefetch_on_insert = false,
				},

				menu = {
					border = "rounded",
					winblend = 0,
					draw = {
						treesitter = { "lsp", "copilot" },
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind", gap = 1 },
						},
					},
				},

				-- By default, you may press `<c-space>` to show the documentation.
				-- Optionally, set `auto_show = true` to show the documentation after a delay.
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = {
						border = "rounded",
						winblend = 0,
					},
				},
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer", "copilot" },

				providers = {
					lsp = {
						score_offset = 90,
					},
					path = {
						score_offset = 40,
					},
					snippets = {
						score_offset = 50,
					},
					buffer = {
						score_offset = -100,
						min_keyword_length = 3,
					},
					copilot = {
						module = "blink-copilot",
						async = true,
					},
				},
			},

			snippets = { preset = "mini_snippets" },

			-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
			-- which automatically downloads a prebuilt binary when enabled.
			--
			-- By default, we use the Lua implementation instead, but you may enable
			-- the rust implementation via `'prefer_rust_with_warning'`
			--
			-- See :h blink-cmp-config-fuzzy for more information
			fuzzy = {
				implementation = "lua",
				prebuilt_binaries = {
					download = true,
				},
			},

			-- Shows a signature help window while you type arguments for a function
			signature = {
				enabled = true,
				window = {
					border = "rounded",
					winblend = 0,
				},
			},
		},
	},
}
