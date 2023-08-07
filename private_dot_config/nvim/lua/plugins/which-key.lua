return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  lazy = true,
  opts = {
    plugins = {
      marks = false,     -- shows a list of your marks on ' and `
      registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      -- No actual key bindings are created
      presets = {
        operators = false,    -- adds help for operators like d, y, ...
        motions = false,      -- adds help for motions
        text_objects = false, -- help for text objects triggered after entering an operator
        windows = false,      -- default bindings on <c-w>
        nav = false,          -- misc bindings to work with windows
        z = false,            -- bindings for folds, spelling and others prefixed with z
        g = false,            -- bindings for prefixed with g
      },
    },
    operators = { gc = "Comments" }, -- show the currently pressed key and its label as a message in the command line
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
      scroll_down = "<c-d>", -- binding to scroll down inside the popup
      scroll_up = "<c-u>",   -- binding to scroll up inside the popup
    },
    window = {
      border = "single",        -- none, single, double, shadow
      position = "bottom",      -- bottom, top
      margin = { 2, 0, 2, 0 },  -- extra window margin [top, right, bottom, left]
      padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      winblend = 0,
      zindex = 1000,            -- positive value to position WhichKey above other floating windows.
    },
    layout = {
      height = { min = 4, max = 25 },                                             -- min and max height of the columns
      width = { min = 20, max = 50 },                                             -- min and max width of the columns
      spacing = 3,                                                                -- spacing between columns
      align = "left",                                                             -- align columns left, center or right
    },
    ignore_missing = false,                                                       -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true,                                                             -- show help message on the command line when the popup is visible
    show_keys = true,
    triggers = "auto",                                                            -- automatically setup triggers
    triggers_blacklist = {
      i = { "j", "k" },
      v = { "j", "k" },
    },
    -- Disabled by default for Telescope
    disable = {
      buftypes = {},
      filetypes = { "TelescopePrompt" },
    },
  },
  config = function(_, opts)
    local which_key = require("which-key")
    which_key.setup(opts)
    which_key.register({
      mode = { "n", "v" },
      [";"] = { ":Alpha<CR>", "Dashboard" },
      ["<space>"] = { "<cmd>Telescope find_files hidden=true<cr>", "Find File" },
      w = { ":w!<CR>", "Save" },
      q = { ":confirm q<CR>", "Quit" },
      c = { ":bd<CR>", "Close Buffer" },
      h = { ":nohlsearch<CR>", "No Highlight" },
      p = { "<cmd>Telescope treesitter<CR>", "List Symbols" },
      f = { "<cmd>lua require('config.utils').telescope_git_or_file()<CR>", "Find Files" },
      v = "Go to definition in a split",
      a = "Swap next param",
      A = "Swap previous param",
      U = { ":UndotreeToggle<CR>", "Toggle UndoTree" },
      m = {
        name = "Marks",
        m = { "<cmd>Telescope marks<cr>", "Marks" },
      },
      r = {
        name = "Replace",
      },
      b = {
        name = "Buffers",
        f = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },
      },
      g = {
        name = "+Git",
        k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
        l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
        p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
        r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
        R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
        j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
        s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
        u = {
          "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
          "Undo Stage Hunk",
        },
        o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
        C = {
          "<cmd>Telescope git_bcommits<cr>",
          "Checkout commit(for current file)",
        },
        d = {
          "<cmd>Gitsigns diffthis HEAD<cr>",
          "Git Diff",
        },
      },
      l = {
        name = "+LSP",
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        A = { "<cmd>lua vim.lsp.buf.range_code_action()<cr>", "Range Code Actions" },
        d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Definition" },
        D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Declaration" },
        i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Implementation" },
        o = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Type Definition" },
        R = { "<cmd>Telescope lsp_references<cr>", "References" },
        m = { "<cmd>Mason<cr>", "Mason" },
        s = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Display Signature Information" },
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename all references" },
        f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
        K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
        l = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics (Trouble)" },
        L = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics (Trouble)" },
        w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
        t = { [[ <Esc><Cmd>lua require('telescope').extensions.refactoring.refactors()<CR>]], "Refactor" },

        h = { "<cmd>lua vim.lsp.inlay_hint(0, true)<cr>", "Enable Inlay Hints" },
        H = { "<cmd>lua vim.lsp.inlay_hint(0, false)<cr>", "Disable Inlay Hints" },
      },
      s = {
        name = "+Search",
        f = { "<cmd>Telescope find_files hidden=true<cr>", "Find File" },
        h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
        H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
        M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
        o = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
        R = { "<cmd>Telescope registers<cr>", "Registers" },
        t = { "<cmd>Telescope live_grep hidden=true<cr>", "Live Grep" },
        T = { "<cmd>Telescope grep_string hidden=true<cr>", "Grep String" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        C = { "<cmd>Telescope commands<cr>", "Commands" },
        l = { "<cmd>Telescope resume<cr>", "Resume last search" },
        c = { "<cmd>Telescope git_commits<cr>", "Git commits" },
        B = { "<cmd>Telescope git_branches<cr>", "Git branches" },
        s = { "<cmd>Telescope git_status<cr>", "Git status" },
        S = { "<cmd>Telescope git_stash<cr>", "Git stash" },
        z = { "<cmd>Telescope zoxide list<cr>", "Zoxide" },
        e = { "<cmd>Telescope frecency<cr>", "Frecency" },
        b = { "<cmd>Telescope buffers<cr>", "Buffers" },
        p = { "<cmd>Telescope projects<cr>", "Projects" },
        d = {
          name = "+DAP",
          c = { "<cmd>Telescope dap commands<cr>", "Dap Commands" },
          b = { "<cmd>Telescope dap list_breakpoints<cr>", "Dap Breakpoints" },
          g = { "<cmd>Telescope dap configurations<cr>", "Dap Configurations" },
          v = { "<cmd>Telescope dap variables<cr>", "Dap Variables" },
          f = { "<cmd>Telescope dap frames<cr>", "Dap Frames" },
        }
      },
      T = {
        name = "+Todo",
        t = { "<cmd>TodoTelescope<cr>", "Todo" },
        T = { "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", "Todo/Fix/Fixme" },
        x = { "<cmd>TodoTrouble<cr>", "Todo (Trouble)" },
        X = { "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr><cr>", "Todo/Fix/Fixme (Trouble)" },
      },
      d = {
        name = "Debug",
        b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
        c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
        i = { "<cmd>lua require'dap'.step_into()<cr>", "Into" },
        o = { "<cmd>lua require'dap'.step_over()<cr>", "Over" },
        O = { "<cmd>lua require'dap'.step_out()<cr>", "Out" },
        r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Repl" },
        l = { "<cmd>lua require'dap'.run_last()<cr>", "Last" },
        u = { "<cmd>lua require'dapui'.toggle()<cr>", "UI" },
        x = { "<cmd>lua require'dap'.terminate()<cr>", "Exit" },
      },
      t = {
        name = "+Tests"
      },
      ['\\'] = {
        name = "+Terminal",
        h = { "<cmd>ToggleTerm direction=horizontal<cr>", "Horizontal" },
        v = { "<cmd>ToggleTerm direction=vertical size=100 <cr>", "Vertical" },
        f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
      }
    }, {
      mode = "n",
      prefix = "<leader>",
    })

    which_key.register({
      gd = "Goto definitio",
      gD = "Goto declaration",
      gi = "Goto implementation",
      gl = "Goto float diagnostics",
      go = "Goto type definition",
      gr = "Goto references",
      ["[t"] = { "<cmd>:cprev<cr>", "Previous quickfix" },
      ["]t"] = { "<cmd>:cnext<cr>", "Next quickfix" },
    })
  end
}
