return {
  {
    "dmmulroy/tsc.nvim",
    name = "tsc",
    cmd = "TSC",
    lazy = true,
    config = true,
    -- opts = {
    --   flags = {
    --     build = true,
    --   },
    -- },
  },
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = true,
    keys = {
      {
        "<leader>ns",
        "<cmd>lua require('package-info').show({ force = true })<cr>",
        desc = "Display latest package version",
      },
      {
        "<leader>nd",
        "<cmd>lua require('package-info').delete()<cr>",
        desc = "Delete package",
      },
      {
        "<leader>np",
        "<cmd>lua require('package-info').change_version()<cr>",
        desc = "Install new version",
      },
      {
        "<leader>ni",
        "<cmd>lua require('package-info').install()<cr>",
        desc = "Install new package",
      },
    },
  },
}
