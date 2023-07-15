return {
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      global_settings = {
        save_on_toggle = true,
        enter_on_sendcmd = true,
      },
    },
    keys = {
      {
        "<leader>ha",
        function()
          require("harpoon.mark").add_file()
        end,
        desc = "Harpoon add file",
      },
      {
        "<leader>hm",
        function()
          require("harpoon.mark").add_file()
        end,
        desc = "Harpoon add file",
      },
      {
        "<leader>hc",
        function()
          require("harpoon.cmd-ui").toggle_quick_menu()
        end,
        desc = "Harpoon command Menu",
      },
      {
        "<leader>hn",
        function()
          require("harpoon.ui").nav_next()
        end,
        desc = "Harpoon next file",
      },
      {
        "<leader>hp",
        function()
          require("harpoon.ui").nav_prev()
        end,
        desc = "Harpoon previous file",
      },
      {
        "<leader>1",
        function()
          require("harpoon.ui").nav_file(1)
        end,
        desc = "Harpoon file 1",
      },
      {
        "<leader>2",
        function()
          require("harpoon.ui").nav_file(2)
        end,
        desc = "Harpoon file 2",
      },
      {
        "<leader>3",
        function()
          require("harpoon.ui").nav_file(3)
        end,
        desc = "Harpoon file 3",
      },
      {
        "<leader>4",
        function()
          require("harpoon.ui").nav_file(4)
        end,
        desc = "Harpoon file 4",
      },
      {
        "<leader>5",
        function()
          require("harpoon.ui").nav_file(5)
        end,
        desc = "Harpoon file 5",
      },
      {
        "<leader>6",
        function()
          require("harpoon.ui").nav_file(6)
        end,
        desc = "Harpoon file 6",
      },
      {
        "<leader>7",
        function()
          require("harpoon.ui").nav_file(7)
        end,
        desc = "Harpoon file 7",
      },
      {
        "<leader>8",
        function()
          require("harpoon.ui").nav_file(8)
        end,
        desc = "Harpoon file 8",
      },
      {
        "<leader>9",
        function()
          require("harpoon.ui").nav_file(9)
        end,
        desc = "Harpoon file 9",
      },
      {
        "<A-1>",
        function()
          require("harpoon.ui").nav_file(1)
        end,
        desc = "Harpoon file 1",
      },
      {
        "<A-2>",
        function()
          require("harpoon.ui").nav_file(2)
        end,
        desc = "Harpoon file 2",
      },
      {
        "<A-3>",
        function()
          require("harpoon.ui").nav_file(3)
        end,
        desc = "Harpoon file 3",
      },
      {
        "<A-4>",
        function()
          require("harpoon.ui").nav_file(4)
        end,
        desc = "Harpoon file 4",
      },
      {
        "<A-5>",
        function()
          require("harpoon.ui").nav_file(5)
        end,
        desc = "Harpoon file 5",
      },
      {
        "<A-6>",
        function()
          require("harpoon.ui").nav_file(6)
        end,
        desc = "Harpoon file 6",
      },
      {
        "<A-7>",
        function()
          require("harpoon.ui").nav_file(7)
        end,
        desc = "Harpoon file 7",
      },
      {
        "<A-8>",
        function()
          require("harpoon.ui").nav_file(8)
        end,
        desc = "Harpoon file 8",
      },
      {
        "<A-9>",
        function()
          require("harpoon.ui").nav_file(9)
        end,
        desc = "Harpoon file 9",
      },
      {
        "<leader>ht1",
        function()
          require("harpoon.tmux").gotoTerminal(1)
        end,
        desc = "Tmux window 1",
      },
      {
        "<leader>ht2",
        function()
          require("harpoon.tmux").gotoTerminal(2)
        end,
        desc = "Tmux window 2",
      },
      {
        "<leader>hx1",
        function()
          require("harpoon.tmux").sendCommand(1, 1)
        end,
        desc = "Tmux command 1 to window 1",
      },
      {
        "<leader>hx2",
        function()
          require("harpoon.tmux").sendCommand(2, 1)
        end,
        desc = "Tmux command 2 to window 1",
      },
    },
  },
}
