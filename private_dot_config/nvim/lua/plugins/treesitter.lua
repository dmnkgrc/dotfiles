return {
  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    config = true,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "mrjones2014/nvim-ts-rainbow",
      "windwp/nvim-ts-autotag",
    },
    opts = {
      ensure_installed = {
        "bash",
        -- "comment", -- comments are slowing down TS bigtime, so disable for now
        "css",
        "diff",
        "gitignore",
        "graphql",
        "vimdoc",
        "html",
        "http",
        "javascript",
        "jsdoc",
        "jsonc",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "scss",
        "sql",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "vhs",
        "vim",
        "vue",
        "wgsl",
        "yaml",
        -- "wgsl",
        "json",
        -- "markdown",
      },
      highlight = { enable = true },
      -- indent = { enable = false },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = true, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = "o",
          toggle_hl_groups = "i",
          toggle_injected_languages = "t",
          toggle_anonymous_nodes = "a",
          toggle_language_display = "I",
          focus_language = "f",
          unfocus_language = "F",
          update = "R",
          goto_node = "<cr>",
          show_help = "?",
        },
      },
      autotag = {
        enable = true,
      },
      rainbow = {
        enable = true,
      },
    },
  },
}
