local colors = {
  fg = "#76787d",
  bg = "#252829",
}
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local function location()
        local line = vim.fn.line(".")
        local col = vim.fn.virtcol(".")
        return string.format("Ln %d,Col %d", line, col)
      end
      local diagnostics = {
        "diagnostics",

        sources = { "nvim_diagnostic" },
        sections = { "error", "warn" },

        diagnostics_color = {
          error = "Statusline",
          warn = "Statusline",
          info = "Statusline",
          hint = "Statusline",
        },
        symbols = {
          error = "" .. " ",
          warn = "" .. " ",
          info = "I",
          hint = "H",
        },
        colored = false, -- Displays diagnostics status in color if set to true.
        update_in_insert = false, -- Update diagnostics in insert mode.
        always_visible = true, -- Show diagnostics even if there are none.
      }

      local filetype = function()
        return vim.bo.filetype
      end

      require("lualine").setup({
        options = {
          theme = {
            normal = {
              a = { fg = colors.fg, bg = colors.bg },
              b = { fg = colors.fg, bg = colors.bg },
              c = { fg = colors.fg, bg = colors.bg },
            },
            insert = { a = { fg = colors.fg, bg = colors.bg }, b = { fg = colors.fg, bg = colors.bg } },
            visual = { a = { fg = colors.fg, bg = colors.bg }, b = { fg = colors.fg, bg = colors.bg } },
            command = { a = { fg = colors.fg, bg = colors.bg }, b = { fg = colors.fg, bg = colors.bg } },
            replace = { a = { fg = colors.fg, bg = colors.bg }, b = { fg = colors.fg, bg = colors.bg } },

            -- inactive = {
            --   a = { bg = colors.fg, fg = colors.bg },
            --   b = { bg = colors.fg, fg = colors.bg },
            --   c = { bg = colors.fg, fg = colors.bg },
            -- },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { diagnostics },
          lualine_c = {
            "filename",
          },
          lualine_x = { location },
          lualine_y = { filetype },
          lualine_z = { "progress" },
        },
      })
    end,
  },
  {
    "stevearc/oil.nvim",
    name = "oil",
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
    config = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>lua require('oil').open()<cr>", desc = "Open parent directory" },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
    },
  },
}
