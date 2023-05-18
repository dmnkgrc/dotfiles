return {
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("harpoon")
      end,
    },
    keys = {
      { "<leader>hf", ":Telescope harpoon marks<CR>", "Harpoon Marks" },
      { "<leader>ss", false },
      { "<leader>sR", false },
    },
  },
}
