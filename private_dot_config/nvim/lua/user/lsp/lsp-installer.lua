local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
	local on_attach = require("user.lsp.handlers").on_attach
	local capabilities = require("user.lsp.handlers").capabilities
	local opts = {
		on_attach = on_attach,
		capabilities = capabilities,
	}

	if server.name == "tsserver" then
		local lspconfig = require("lspconfig")
		local ts_utils = require("nvim-lsp-ts-utils")
		local ts_utils_settings = {
			debug = true,
			import_all_scan_buffers = 100,
			update_imports_on_move = false,
      enable_import_on_completion = true,
      always_organize_imports = false,
			-- filter out dumb module warning
			filter_out_diagnostics_by_code = { 80001 },
		}
		opts.root_dir = lspconfig.util.root_pattern("package.json")
		opts.init_options = ts_utils.init_options
		opts.filetypes = { "typescript", "typescriptreact", "typescript.tsx" }
		opts.flags = {
			debounce_text_changes = 150,
		}
		opts.on_attach = function(client, bugnr)
			on_attach(client, bufnr)
			ts_utils.setup(ts_utils_settings)
			ts_utils.setup_client(client)

      local opts = { silent = true }
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gI", ":TSLspRenameFile<CR>", opts)
			vim.api.nvim_buf_set_keymap(bufnr, "n", "go", ":TSLspImportAll<CR>", opts)
		end
	end

  if server.name == "eslint" then
		opts.on_attach = function(client, bugnr)
			on_attach(client, bufnr)

      local opts = { silent = true }
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gF", ":EslintFixAll<CR>", opts)
		end
  end

	if server.name == "jsonls" then
		local jsonls_opts = require("user.lsp.settings.jsonls")
		opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
	end

	if server.name == "sumneko_lua" then
		local sumneko_opts = require("user.lsp.settings.sumneko_lua")
		opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
	end

	-- This setup() function is exactly the same as lspconfig's setup function.
	-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	server:setup(opts)
end)
