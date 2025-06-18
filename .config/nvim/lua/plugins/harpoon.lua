return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local keys = {
        {
          '<leader>H',
          function()
            require('harpoon'):list():add()
          end,
          desc = 'Harpoon File',
        },
        {
          '<leader>h',
          function()
            local harpoon = require 'harpoon'
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = 'Harpoon Quick Menu',
        },
        {
          '<leader>fh',
          function()
            require('snacks').picker {
              finder = function()
                local harpoon = require 'harpoon'
                local file_paths = {}
                for _, item in ipairs(harpoon:list().items) do
                  table.insert(file_paths, {
                    text = item.value,
                    file = item.value,
                  })
                end
                return file_paths
              end,
              win = {
                input = {
                  keys = {
                    ['dd'] = { 'harpoon_delete', mode = { 'n', 'x' } },
                  },
                },
                list = {
                  keys = {
                    ['dd'] = { 'harpoon_delete', mode = { 'n', 'x' } },
                  },
                },
              },
              actions = {
                harpoon_delete = function(picker, item)
                  local harpoon = require 'harpoon'
                  local to_remove = item or picker:selected()
                  table.remove(harpoon:list().items, to_remove.idx)
                  picker:find {
                    refresh = true,
                  }
                end,
              },
            }
          end,
          desc = 'Find harpoon',
        },
      }

      for i = 1, 5 do
        table.insert(keys, {
          '<leader>' .. i,
          function()
            require('harpoon'):list():select(i)
          end,
          desc = 'Harpoon to File ' .. i,
        })
      end
      return keys
    end,
  },
}
