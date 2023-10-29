return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        javascript = { { "prettierd" } },
        typescript = { { "prettierd" } },
        javascriptreact = { { "prettierd" } },
        typescriptreact = { { "prettierd" } },
        svelte = { { "prettierd" } },
        css = { { "prettierd" } },
        html = { { "prettierd" } },
        json = { { "prettierd" } },
        yaml = { { "prettierd" } },
        markdown = { { "prettierd" } },
        graphql = { { "prettierd" } },
        lua = { "stylua" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    },
    keys = {
      {
        "<leader>lf",
        function()
          require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
        end,
        mode = { "n", "v" },
        desc = "Format code",
      },
    },
  },
}
