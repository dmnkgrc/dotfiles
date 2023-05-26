local mason_registry = require("mason-registry")
local rust_tools_opts = {
  tools = {
    hover_actions = {
      auto_focus = true,
    },
    inlay_hints = {
      auto = true,
      show_parameter_hints = true,
    },
  },
  server = {
     on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "K", "<cmd>RustHoverActions<cr>", { buffer = bufnr })
      -- Code action groups
    end,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          features = "all",
        },
        -- Add clippy lints for Rust.
        checkOnSave = true,
        check = {
          command = "clippy",
          features = "all",
        },
        procMacro = {
          enable = true,
        },
      },
    },
  },
}
if mason_registry.has_package("codelldb") then
  -- rust tools configuration for debugging support
  local codelldb = mason_registry.get_package("codelldb")
  local extension_path = codelldb:get_install_path() .. "/extension/"
  local codelldb_path = extension_path .. "adapter/codelldb"
  local liblldb_path = vim.fn.has("mac") == 1 and extension_path .. "lldb/lib/liblldb.dylib"
    or extension_path .. "lldb/lib/liblldb.so"

  rust_tools_opts = vim.tbl_deep_extend("force", rust_tools_opts, {
    dap = {
      adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
    },
  })
end
require("rust-tools").setup(rust_tools_opts)
