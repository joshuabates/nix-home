if vim.g.vscode then
  return {}
end

return {
  {
    'saghen/blink.cmp',
    build = 'nix run .#build-plugin',
    dependencies = { "fang2hou/blink-copilot" },
    opts = {
      keymap = {
        preset = 'enter',
        ['<C-p>'] = {
          function(cmp)
            cmp.show({ providers = { 'copilot' }, })
          end
        },
        ["<c-n>"] = { "show", "select_next", "fallback" },
      },
      signature = { enabled = false },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 100,
          -- window = {
          --   border = 1,
          --   max_height = 30,
          -- }
        },
        ghost_text = {
          enabled = false,
        },
        keyword = { range = 'full' },
        list = { selection = { preselect = false, auto_insert = true } },
        menu = {
          auto_show = function()
            return not vim.b.copilot_enabled;
          end,

          draw = {
            columns = { { "kind_icon" }, { "label", gap = 2 } },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
      },
      sources = {
        default = { 'lsp', 'buffer', 'snippets', 'path' },
        min_keyword_length = 0,
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            -- score_offset = 100,
            async = true,
            opts = {
              max_completions = 5,
              max_attempts = 6,
              debounce = 100,
            }
          },
        },
      },
    },
    opts_extend = { "sources.default" }
  },
  {
    "xzbdmw/colorful-menu.nvim",
    config = function()
      require("colorful-menu").setup({})
    end,
  }
}
