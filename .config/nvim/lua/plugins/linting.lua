return {
  {
    "stevearc/conform.nvim",
    enabled = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.python = { "ruff_format" }
      opts.formatters_by_ft.javascript = { "biome" }
      opts.formatters_by_ft.typescript = { "biome" }
      opts.formatters_by_ft.javascriptreact = { "biome" }
      opts.formatters_by_ft.typescriptreact = { "biome" }
      opts.formatters_by_ft.json = { "biome" }

      -- Custom formatter definitions to use .trunk/configs
      opts.formatters = opts.formatters or {}
      opts.formatters.biome = {
        command = "biome",
        args = function(self, ctx)
          local config_path = vim.fn.findfile("biome.json", ctx.dirname .. ";")
          if config_path == "" then
            config_path = vim.fn.findfile(".trunk/configs/biome.json", ctx.dirname .. ";")
          end
          if config_path ~= "" then
            return { "format", "--stdin-file-path", "$FILENAME", "--config-path", config_path }
          end
          vim.notify("Biome formatter using default config", vim.log.levels.INFO)
          return { "format", "--stdin-file-path", "$FILENAME" }
        end,
        stdin = true,
      }

      return opts
    end,
  },
  {
    "trunk-io/neovim-trunk",
    enabled = false,
  },
}
