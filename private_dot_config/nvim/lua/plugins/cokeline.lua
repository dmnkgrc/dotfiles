return {
  'willothy/nvim-cokeline',
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "kyazdani42/nvim-web-devicons",
  },
  keys = {
    { "<leader>bp", "<Plug>(cokeline-focus-prev)", desc = "Previous", },
    { "<leader>bn", "<Plug>(cokeline-focus-next)", desc = "Next", },
    { "<leader>bW", "<cmd>noautocmd w<cr>",        desc = "Save without formatting (noautocmd)", },
    { "<leader>bj", "<Plug>(cokeline-pick-focus)", desc = "Jump" },
    {
      "<leader>bx",
      "<Plug>(cokeline-pick-close)",
      desc = "Pick which buffer to close",
    }
  },
  lazy = false,
  config = function()
    local is_picking_focus = require('cokeline/mappings').is_picking_focus
    local is_picking_close = require('cokeline/mappings').is_picking_close

    local inactive_bg = '#1d2021'
    local active_bg = '#282828'
    local fg = '#d4be98'
    local fg_dim = '#7c6f64'
    local warning = '#e78a4e'
    local error = '#ea6962'


    require('cokeline').setup {
      show_if_buffers_are_at_least = 2,

      default_hl = {
        fg = function(buffer) return buffer.is_focused and fg or fg_dim end,
        bg = function(buffer) return buffer.is_focused and active_bg or inactive_bg end,
      },
      components = {
        {
          text = function(buffer) return (buffer.index ~= 1) and '▎  ' or '   ' end,
          fg = fg_dim,
        },
        {
          text = function(buffer)
            return
                (is_picking_focus() or is_picking_close())
                and buffer.pick_letter .. ' '
                or buffer.devicon.icon
          end,
          fg = function(buffer)
            if buffer.diagnostics.errors ~= 0 or is_picking_close() then return error end
            if buffer.diagnostics.warnings ~= 0 or is_picking_focus() then return warning end
            return buffer.is_focused and buffer.devicon.color
          end,
        },
        {
          text = ' '
        },
        {
          text = function(buffer) return buffer.filename .. '  ' end,
        },
        {
          text = function(buffer)
            if buffer.is_readonly then return '' end
            if buffer.is_modified then return '' end
            return 'X'
          end,
          delete_buffer_on_left_click = true,
        },
        {
          text = '   ',
        },
      },
    }
  end
}
