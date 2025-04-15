if not vim.g.vscode then
  return {
    {
      'saghen/blink.cmp',
      build = 'nix run .#build-plugin',
      dependencies = { "fang2hou/blink-copilot" },
      opts = {
        keymap = {
          preset = 'enter',
          ['<Tab>'] = {
            function(cmp)
              cmp.show({ providers = { 'copilot' }, })
            end
          },
          -- may want to disable autocomplete auto menu and use this?
          ["<c-n>"] = { "show", "select_next", "fallback" },
        },
        signature = { enabled = false },
        completion = {
          documentation = {
            auto_show = true,
          },
          ghost_text = {
            enabled = false,
          },
          keyword = { range = 'full' },
          list = { selection = { preselect = false, auto_insert = true } },
          menu = {
            -- auto_show = false,
            draw = {
              columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
            },
          },
        },
        sources = {
          default = { 'lsp', 'buffer', 'snippets', 'path' },
          providers = {
            copilot = {
              name = "copilot",
              module = "blink-copilot",
              score_offset = 100,
              async = true,
            },
          },
        },
      },
      opts_extend = { "sources.default" }
    },
  }
end
