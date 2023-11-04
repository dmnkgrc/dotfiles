return {
  {
    "folke/tokyonight.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
      })
      -- vim.cmd [[colorscheme tokyonight]]
    end,
  },
  {
    "oxfist/night-owl.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme 'night-owl'
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    enabled = false,
    priority = 1000,
    lazy = false,
    config = function()
      require("kanagawa").setup({
        transparent = true, -- do not set background color
      })
      -- vim.cmd.colorscheme 'kanagawa'
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("nightfox").setup({})
      vim.cmd.colorscheme("nightfox")
    end,
  },
  {
    "kvrohit/mellow.nvim",
    enabled = false,
    priority = 1000,
    lazy = false,
    config = function()
      -- vim.cmd.colorscheme("mellow")
    end,
  },
}
