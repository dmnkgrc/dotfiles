return {
  -- search/replace in multiple files
  {
    'nvim-pack/nvim-spectre',
    build = false,
    cmd = 'Spectre',
    opts = {
      open_cmd = 'noswapfile vnew',
      replace_engine = {
        ['sed'] = {
          cmd = 'sed',
          args = {
            '-i',
            '',
            '-E',
          },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
    },
  },
}
