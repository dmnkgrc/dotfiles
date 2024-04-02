return {
  {
    "telescope.nvim",
    dependencies = {
      {
        "jvgrootveld/telescope-zoxide",
        config = function()
          require("telescope").load_extension("zoxide")
        end,
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      {
        "debugloop/telescope-undo.nvim",
        config = function()
          require("telescope").load_extension("undo")
        end,
      },
      {
        "ThePrimeagen/git-worktree.nvim",
        config = function()
          require("telescope").load_extension("git_worktree")
        end,
      },
      {
        "piersolenski/telescope-import.nvim",
        config = function()
          require("telescope").load_extension("import")
        end,
      },
    },
    keys = {
      { "<space><space>", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find File" },
      { "<space>fu", "<cmd>Telescope undo<cr>", desc = "Toggle UndoTree" },
      { "<leader>sz", "<cmd>Telescope zoxide list<cr>", desc = "Zoxide" },
      -- worktrees
      {
        "<leader>sw",
        "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>",
        desc = "List Git Worktrees",
      },
      {
        "<leader>sW",
        "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>",
        desc = "Create Git Worktree",
      },
      {
        "<leader>si",
        "<cmd>Telescope import<cr>",
        desc = "Import",
      },
    },
    opts = {
      extensions = {
        undo = {},
        import = {
          insert_at_top = true,
        },
      },
    },
  },
}
