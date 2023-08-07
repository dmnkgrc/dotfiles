return {
  {
    "rareitems/put_at_end.nvim",
    keys = { -- Basic lazy loading
      -- Plugin doesn't set any keymaps you have to set your own
      {
        "<C-;>",
        function()
          require("put_at_end").put_semicolon()
        end,
        desc = "Put a semicolon at the end of the line",
      },
      {
        "<C-.>",
        function()
          require("put_at_end").put_period()
        end,
        desc = "Put a period at the end of the line",
      },
      {
        "<C-,>",
        function()
          require("put_at_end").put_comma()
        end,
        desc = "Put a comma at the end of the line",
      },
    },
  },
  {
    "MaximilianLloyd/tw-values.nvim",
    keys = {
      { "<leader>sv", "<cmd>TWValues<cr>", desc = "Show tailwind CSS values" },
    },
    opts = {
      border = "rounded",         -- Valid window border style,
      show_unknown_classes = true -- Shows the unknown classes popup
    }
  },
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
}
