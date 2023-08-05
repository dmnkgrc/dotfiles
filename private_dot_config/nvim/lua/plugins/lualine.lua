return {
  "nvim-lualine/lualine.nvim",
  enabled = true,
  lazy = false,
  event = { "BufReadPost", "BufNewFile", "VeryLazy" },
  config = function() -- Custom mode names.
    local P = require 'kanagawa.colors'.setup()
    local mode_map = {
      ['COMMAND'] = 'COMMND',
      ['V-BLOCK'] = 'V-BLCK',
      ['TERMINAL'] = 'TERMNL',
    }
    local function fmt_mode(s) return mode_map[s] or s end

    -- Get the current buffer's filetype.
    local function get_current_filetype() return vim.api.nvim_buf_get_option(0, 'filetype') end

    local function get_native_lsp()
      local buf_ft = get_current_filetype()
      local clients = vim.lsp.get_active_clients()
      if next(clients) == nil then return '' end
      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 and client.name ~= 'copilot' then return client.name end
      end
      return ''
    end

    require("lualine").setup {
      options = {
        theme = "kanagawa",
        icons_enabled = true,
        section_separators = "",
        component_separators = "",
        disabled_filetypes = {
          statusline = {
            'help',
            'startify',
            'dashboard',
            'neogitstatus',
            'NvimTree',
            'Trouble',
            'alpha',
            'lir',
            'Outline',
            'spectre_panel',
            'toggleterm',
            'qf',
          },
          winbar = {},
        },
      },
      sections = {
        lualine_a = {
          {
            'mode',
            fmt = fmt_mode,
            icon = { '' },
            separator = { right = ' ', left = '' },
          },
        },
        lualine_b = { "branch" },
        lualine_c = {
          -- "filename",
          {
            "filetype",
            icon_only = true,
            separator = "",
            padding = {
              left = 1, right = 0 }
          },
          {
            "filename",
            path = 1,
            symbols = {
              modified = "  ",
              readonly = "",
              unnamed = ""
            }
          },
          { "diagnostics", sources = { "nvim_lsp" }, symbols = { error = " ", warn = " ", info = " " } },
        },
        lualine_x = {
          {
            get_native_lsp,
            padding = 2,
            separator = ' ',
            icon = { ' ' },
          },
          "encoding" },
        lualine_y = {},
        lualine_z = {
          {
            'location',
            icon = { '', align = 'left' },
          },
          {
            'progress',
            icon = { '', align = 'left' },
            separator = { right = '', left = '' },
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {

        },
        lualine_z = {
        },
      },
      tabline = {},
      extensions = { "lazy" },
    }
  end,
}
