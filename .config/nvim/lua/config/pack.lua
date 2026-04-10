--- vim.pack: hooks before first `vim.pack.add()`, then `add_all()`. See :h vim.pack
local M = {}

local function is_fff_spec(spec)
	if not spec then
		return false
	end

	if spec.name == "fff.nvim" then
		return true
	end

	local src = spec.src
	return type(src) == "string" and src:find("dmtrKovalenko/fff.nvim", 1, true) ~= nil
end

local function ensure_fff_backend(force)
	pcall(vim.cmd.packadd, "fff.nvim")

	local ok_download, download = pcall(require, "fff.download")
	if not ok_download then
		vim.notify("Failed to load fff.download for backend setup.", vim.log.levels.WARN)
		return
	end

	local has_binary = false
	local ok_path, binary_path = pcall(download.get_binary_path)
	if ok_path and type(binary_path) == "string" then
		local stat = vim.uv.fs_stat(binary_path)
		has_binary = stat and stat.type == "file" or false
	end

	if has_binary and not force then
		return
	end

	local ok_build, err = pcall(download.download_or_build_binary)
	if not ok_build then
		vim.notify(("Failed to set up fff backend: %s"):format(err), vim.log.levels.ERROR)
	end
end

function M.register_hooks()
	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			local spec = ev.data.spec
			local kind = ev.data.kind

			if is_fff_spec(spec) and (kind == "install" or kind == "update") then
				ensure_fff_backend(true)
			end

			if spec and spec.name == "nvim-treesitter" and (kind == "install" or kind == "update") then
				if not ev.data.active then
					vim.cmd.packadd("nvim-treesitter")
				end
				pcall(vim.cmd.TSUpdate, "all")
			end
		end,
	})
end

function M.add_all()
	-- During init.lua sourcing, vim.pack defaults load=false (|:packadd!|); Lua
	-- requires from plugin modules need full load so rtp/package.path resolve.
	vim.pack.add({
		"https://github.com/nvim-lua/plenary.nvim",
		"https://github.com/MunifTanjim/nui.nvim",
		"https://github.com/rcarriga/nvim-notify",
		"https://github.com/antoinemadec/FixCursorHold.nvim",
		"https://github.com/nvim-neotest/nvim-nio",
		"https://github.com/kevinhwang91/promise-async",
		"https://github.com/nvim-tree/nvim-web-devicons",
		"https://github.com/rafamadriz/friendly-snippets",
		"https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
		"https://github.com/nvim-treesitter/nvim-treesitter",
		"https://github.com/windwp/nvim-ts-autotag",
		"https://github.com/mason-org/mason.nvim",
		"https://github.com/neovim/nvim-lspconfig",
		"https://github.com/SmiteshP/nvim-navic",
		"https://github.com/mason-org/mason-lspconfig.nvim",
		{ src = "https://github.com/saghen/blink.cmp", version = "v1" },
		"https://github.com/oskarnurm/koda.nvim",
		"https://github.com/rebelot/kanagawa.nvim",
		"https://github.com/stevearc/conform.nvim",
		"https://github.com/nvimdev/dashboard-nvim",
		"https://github.com/sindrets/diffview.nvim",
		"https://github.com/dmtrKovalenko/fff.nvim",
		"https://github.com/folke/flash.nvim",
		"https://github.com/lewis6991/gitsigns.nvim",
		"https://github.com/vuciv/golf",
		"https://github.com/MagicDuck/grug-far.nvim",
		{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
		"https://github.com/smjonas/inc-rename.nvim",
		"https://github.com/lukas-reineke/indent-blankline.nvim",
		"https://github.com/echasnovski/mini.nvim",
		"https://github.com/nvim-neotest/neotest",
		"https://github.com/nvim-neotest/neotest-jest",
		"https://github.com/folke/noice.nvim",
		"https://github.com/brenoprata10/nvim-highlight-colors",
		"https://github.com/kevinhwang91/nvim-ufo",
		"https://github.com/stevearc/oil.nvim",
		"https://github.com/folke/sidekick.nvim",
		"https://github.com/mrjones2014/smart-splits.nvim",
		"https://github.com/folke/snacks.nvim",
		"https://github.com/luukvbaal/statuscol.nvim",
		"https://github.com/folke/todo-comments.nvim",
		"https://github.com/folke/trouble.nvim",
		"https://github.com/dmmulroy/ts-error-translator.nvim",
		"https://github.com/dmmulroy/tsc.nvim",
		"https://github.com/mbbill/undotree",
		"https://github.com/tpope/vim-fugitive",
		"https://github.com/folke/which-key.nvim",
		"https://github.com/sourcegraph/amp.nvim",
	}, { load = true })

	-- Ensure fff backend exists even when plugin is already installed but its
	-- binary is missing (e.g. after cache cleanup or failed previous build).
	vim.schedule(function() ensure_fff_backend(false) end)
end

return M
