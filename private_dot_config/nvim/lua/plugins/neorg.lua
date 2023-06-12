return {
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    opts = {
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.presenter"] = {
          config = {
            zen_mode = "zen-mode",
          },
        }, -- Adds presentation capability
        ["core.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              work = "~/notes/work",
              personal = "~/notes/personal",
            },
          },
        },
      },
    },
    dependencies = { "nvim-lua/plenary.nvim", "folke/zen-mode.nvim" },
  },
}
