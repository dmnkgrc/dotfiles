return {
  {
    'echasnovski/mini.surround',
    opts = {
      mappings = {
        add = 'gza',        -- Add surrounding in Normal and Visual modes
        delete = 'gzd',     -- Delete surrounding
        find = 'gzf',       -- Find surrounding (to the right)
        find_left = 'gzF',  -- Find surrounding (to the left)
        highlight = 'gzh',  -- Highlight surrounding
        replace = 'gzr',    -- Replace surrounding
        update_n_lines = 'gzn', -- Update `n_lines`

        suffix_last = 'l',  -- Suffix to search with "prev" method
        suffix_next = 'n',  -- Suffix to search with "next" method
      },
    }
  },
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },
  {
    'echasnovski/mini.splitjoin'
  },
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function()
      -- don't use animate when scrolling with the mouse
      local mouse_scrolled = false
      for _, scroll in ipairs({ "Up", "Down" }) do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require("mini.animate")
      return {
        resize = {
          timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
        },
        scroll = {
          timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
          subscroll = animate.gen_subscroll.equal({
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          }),
        },
      }
    end,
  },
}
