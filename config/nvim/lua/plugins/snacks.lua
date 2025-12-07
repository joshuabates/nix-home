if vim.g.vscode then
  return {}
end

local S = require("user.snacks")

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function(_, opts)
      local Snacks = require("snacks")
      Snacks.setup(opts)
      
      -- Create TypeScript types toggle
      Snacks.toggle({
        name = "TypeScript Types",
        get = function()
          -- Check if conceal.nvim is loaded and get its state
          local ok, conceal = pcall(require, "conceal")
          if ok then
            return conceal.is_enabled("typescript") or conceal.is_enabled("typescriptreact")
          end
          return vim.o.conceallevel > 0
        end,
        set = function(state)
          -- Toggle conceal.nvim if available
          local ok, conceal = pcall(require, "conceal")
          if ok then
            conceal.toggle()
          else
            -- Fallback to conceallevel
            if state then
              vim.o.conceallevel = 3
              vim.o.concealcursor = "nc"
            else
              vim.o.conceallevel = 0
            end
          end
        end,
      }):map("<leader>ut")
    end,
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          }
        }
      },
      debug = { enabled = true },
      dim = { enabled = true },
      explorer = {
        enabled = true
      },
      input = { enabled = true },
      notifier = { enabled = true },
      notify = { enabled = false },
      picker = {
        enabled = true,
        ui_select = true,
        sources = {
          explorer = {
            auto_close = true,
            layout = {
              preview = true,
              preset = 'default',
            },
            --   box    = 'vertical',
            --   row    = 0,
            --   col    = 0,
            --   border = 'rounded',
            --   {
            --     win = 'input',
            --     height = 1,
            --     border = 'rounded',
            --     title = 'Find {title} {live} {flags}',
            --     title_pos = 'center',
            --   },
            --   {
            --     box = 'horizontal',
            --     {
            --       win = 'list',
            --     },
            --     {
            --       win = 'preview',
            --       border = 'left',
            --       width = 0.6,
            --     },
            --   },
            -- },
          },
        },
      },
      scratch = {
        enabled = true,
        ft = "markdown"
      },
      toggle = { enabled = true },
      quickfile = { enabled = true },
      words = { enabled = true },
      zen = {
        enabled = true,
        win = {
          backdrop = {
            transparent = false
          }
        },
        on_open = function()
          vim.fn.system({ "kitty", "@", "goto-layout", "stack" })
        end,
        on_close = function()
          vim.fn.system({ "kitty", "@", "goto-layout", "tall" })
        end,
      },
      -- TODO:
      --  toggleterm -> terminal, lazygit
      --
      -- win, scroll, scratch, rename?
      --
      -- animate = { enabled = true },
      -- scroll = { enabled = true },
      -- indent = { enabled = true },
      -- scope = { enabled = true },
      -- statuscolumn = { enabled = true },
    },
    keys = {
      -- EXPLORER
      {
        "<leader>we",
        function()
          Snacks.explorer({

          })
        end,
        desc = "File Explorer"
      },

      -- ZEN
      { "<leader>wz",       function() Snacks.zen() end,                                                   desc = "Zen" },
      { "<leader>wo",       function() Snacks.zen.zoom() end,                                              desc = "Zoom" },

      -- PICKER
      { "<leader>fd",       S.searchDirectory,                                                             desc = "Search in dir" },
      { "<leader>ff",       function() S.enhancedPickers.files() end,                                      desc = "Files" },
      { "<leader>t",        function() S.enhancedPickers.files() end,                                      desc = "Files" },
      { "<leader>f<space>", function() S.enhancedPickers.files() end,                                      desc = "Files" },
      { "<leader>b",        function() Snacks.picker.buffers({ sort_lastused = true }) end,                desc = "Buffers" },
      { "<leader>fQ",       function() Snacks.picker.qflist() end,                                         desc = "Quickfix" },
      { "<leader>fb",       function() Snacks.picker.buffers({ sort_lastused = true }) end,                desc = "Buffer" },
      { "<leader>gb",       function() Snacks.picker.git_branches() end,                                   desc = "Git Branches" },
      { "<leader>gc",       function() Snacks.picker.git_log() end,                                        desc = "Git Commits" },
      { "<leader>gl",       function() Snacks.picker.git_log_line() end,                                   desc = "Git Line History" },
      { "<leader>gf",       function() Snacks.picker.git_log_file() end,                                   desc = "Git File Commits" },
      { "<leader>gh",       function() Snacks.picker.git_stash() end,                                      desc = "Git Stashes" },
      { "<leader>gd",       function() Snacks.picker.git_diff() end,                                       desc = "Git Diff" },
      { "<leader>gs",       function() Snacks.picker.git_status() end,                                     desc = "git status" },
      { "<leader>f/",       function() Snacks.picker.search_history() end,                                 desc = "Search History" },
      { "<leader>f:",       function() Snacks.picker.command_history() end,                                desc = "command history" },
      { "<leader>fj",       function() Snacks.picker.jumps() end,                                          desc = "Last Search" },
      { "<leader>fl",       function() Snacks.picker.resume() end,                                         desc = "Last Search" },
      { "<leader>fm",       function() Snacks.picker.lsp_symbols() end,                                    desc = "LSP Symbols" },
      { "<leader>fq",       function() Snacks.picker.qflist() end,                                         desc = "Quickfix History" },
      { "<leader>frc",      function() Snacks.picker.files({ cwd = "app/controllers" }) end,               desc = "Rails Controllers" },
      { "<leader>frm",      function() Snacks.picker.files({ cwd = "app/models" }) end,                    desc = "Rails Models" },
      { "<leader>frs",      function() Snacks.picker.files({ cwd = "spec" }) end,                          desc = "Rails Specs" },
      { "<leader>fs",       function() S.enhancedPickers.grep() end,                                       desc = "Grep Search" },
      { "<leader>fw",       function() Snacks.picker.grep_word() end,                                      desc = "Search Word",          mode = { "n", "x" } },
      { "<leader>fc",       function() Snacks.scratch.select() end,                                        desc = "Select Scratch Buffer" },
      { "<leader>ws",       function() Snacks.scratch() end,                                               desc = "Toggle Scratch Buffer" },
      { "<leader>xa",       function() Snacks.picker.diagnostics() end,                                    desc = "Project Diagnostics" },
      { "<leader>xx",       function() Snacks.picker.diagnostics_buffer() end,                             desc = "File Diagnostics" },
      { "<leader>hc",       function() Snacks.picker.commands() end,                                       desc = "Commands" },
      { "<leader>hk",       function() Snacks.picker.keymaps() end,                                        desc = "Keymaps" },
      { "<leader>hh",       function() Snacks.picker.help() end,                                           desc = "Help Pages" },
      { "<leader>vc",       function() Snacks.picker.colorschemes() end,                                   desc = "Colorschemes" },
      { "<leader>vl",       function() Snacks.picker.lazy() end,                                           desc = "Lazy specs" },
      { "<leader>vn",       function() Snacks.picker.notifications({ confirm = { "copy", "close" } }) end, desc = "Notifications" },
      { "gr",               function() Snacks.picker.lsp_references({ include_declaration = false }) end,  desc = "Find References" },
      { "gd",               function() Snacks.picker.lsp_definitions() end,                                desc = "Go to Definition" },
    },
  },
}
