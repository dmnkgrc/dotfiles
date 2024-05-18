local coffee = [[
            {
         {   }
          }_{ __{
       .-{   }   }-.
      (   }     {   )
      |`-.._____..-'|
      |             ;--.
      |            (__  \
      |             | )  )
      |             |/  /
      |             /  / 
      |            (  /
      \             y'
       `-.._____..-'
       ]]
return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {},
  },
  {
    'echasnovski/mini.starter',
    event = 'VimEnter',
    dependencies = {
      {
        'folke/persistence.nvim',
      },
    },
    config = function()
      local starter = require 'mini.starter'
      starter.setup {
        header = coffee,
        items = {
          starter.sections.recent_files(10, true),
          { name = 'Load last session', action = 'lua require("persistence").load()', section = 'Session' },
        },
        content_hooks = {
          starter.gen_hook.adding_bullet ' ',
          starter.gen_hook.aligning('center', 'center'),
        },
      }
    end,
  },
}
