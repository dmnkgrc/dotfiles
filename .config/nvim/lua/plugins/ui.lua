return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "meuter/lualine-so-fancy.nvim",
    },
    opts = {
      options = {
        theme = "auto",
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        icons_enabled = true,
        refresh = {
          statusline = 100,
        },
      },
      sections = {
        lualine_a = {
          {},
        },
        lualine_b = {
          { "fancy_branch" },
        },
        lualine_c = {
          {
            "filename",
            path = 1, -- 2 for full path
            symbols = {
              modified = "  ",
              -- readonly = "  ",
              -- unnamed = "  ",
            },
          },
          { "fancy_diagnostics", sources = { "nvim_lsp" }, symbols = { error = " ", warn = " ", info = " " } },
          { "fancy_searchcount" },
        },
        lualine_x = {
          { "fancy_lsp_servers" },
          { "fancy_diff" },
          { "progress" },
        },
        lualine_y = {},
        lualine_z = {
          { "fancy_macro" },
        },
      },
    },
  },
  -- {
  --   "letieu/harpoon-lualine",
  --   dependencies = {
  --     {
  --       "ThePrimeagen/harpoon",
  --       branch = "harpoon2",
  --     },
  --   },
  -- },
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   opts = {
  --     sections = {
  --       lualine_c = { "harpoon2" },
  --     },
  --   },
  -- },
}
