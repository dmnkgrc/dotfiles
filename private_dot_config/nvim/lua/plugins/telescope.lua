local Util = require("lazyvim.util")

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
      { "<leader><space>", Util.telescope("files", { hidden = true }), desc = "Find Files (root dir)" },
      { "<leader>ff", Util.telescope("files", { hidden = true }), desc = "Find Files (root dir)" },
      { "<leader>fF", Util.telescope("files", { hidden = true, cwd = false }), desc = "Find Files (cwd)" },
      { "<leader>hf", ":Telescope harpoon marks<CR>", "Harpoon Marks" },
      { "<leader>ss", "<cmd>lua require('sg.telescope').fuzzy_search_results()<CR>", desc = "Search Sourcegraph" },
      { "<leader>sR", false },
    },
  },
}
