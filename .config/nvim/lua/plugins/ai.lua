return {
  {
    "milanglacier/minuet-ai.nvim",
    name = "minuet",
    opts = {
      provider = "codestral",
      provider_options = {
        openai_fim_compatible = {
          api_key = "OPENROUTER_API_KEY",
          end_point = "https://openrouter.ai/api/v1/completions",
          model = "mistralai/codestral-2501",
          name = "Openrouter",
          optional = {
            max_tokens = 256,
            stop = { "\n\n" },
          },
        },
      },
      codestral = {
        model = "codestral-latest",
        end_point = "https://codestral.mistral.ai/v1/fim/completions",
        api_key = "CODESTRAL_API_KEY",
        stream = true,
        optional = {
          stop = nil, -- the identifier to stop the completion generation
          max_tokens = nil,
        },
      },
    },
    dependencies = {
      {
        "Saghen/blink.cmp",
        opts = {
          keymap = {
            ["<A-y>"] = {
              function(cmp)
                cmp.show({ providers = { "minuet" } })
              end,
            },
          },
          sources = {
            default = { "minuet" },
            providers = {
              minuet = {
                name = "minuet",
                module = "minuet.blink",
                score_offset = 100,
                transform_items = function(ctx, items)
                  for _, item in ipairs(items) do
                    item.kind_icon = "󰊠"
                    item.kind_name = "Minuet"
                  end
                  return items
                end,
              },
            },
          },
        },
      },
    },
  },
  {
    "coder/claudecode.nvim",
    config = true,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree" },
      },
    },
  },
}
