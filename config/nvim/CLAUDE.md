# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the Neovim configuration in this directory.

## Configuration Overview

This is a modern Neovim configuration built with Lua, using lazy.nvim for plugin management and Snacks.nvim for enhanced UI/UX features. The configuration is designed to work both standalone and within VSCode.

## Directory Structure

```
config/nvim/
├── init.lua                 # Entry point, bootstraps lazy.nvim and loads modules
├── lazy-lock.json          # Plugin version lock file
├── TODO.md                 # Development tasks and ideas
├── after/
│   └── ftplugin/          # Filetype-specific settings
│       └── qf.vim         # Quickfix customizations
├── lua/
│   ├── plugins/           # Plugin specifications for lazy.nvim
│   │   ├── init.lua       # Core plugins and mini.nvim setup
│   │   ├── ai.lua         # AI/Copilot integration
│   │   ├── cmp.lua        # Autocompletion setup
│   │   ├── git.lua        # Git integrations (gitsigns, fugitive)
│   │   ├── lsp.lua        # Language Server Protocol configuration
│   │   ├── snacks.lua     # Snacks.nvim UI enhancements
│   │   ├── treesitter.lua # Syntax highlighting and code understanding
│   │   ├── ui.lua         # UI elements (lualine, themes)
│   │   └── windows.lua    # Window management plugins
│   └── user/              # User configuration modules
│       ├── colorscheme.lua # Theme configuration
│       ├── commands.lua    # Custom commands
│       ├── gitsigns.lua    # Git signs configuration
│       ├── icons.lua       # Icon definitions
│       ├── keymaps.lua     # Key mappings
│       ├── lsp_utils.lua   # LSP utilities and handlers
│       ├── lualine.lua     # Status line configuration
│       ├── options.lua     # Neovim options
│       ├── ruby.lua        # Ruby-specific settings
│       ├── snacks.lua      # Snacks.nvim utilities
│       ├── testing.lua     # Test runner configuration
│       ├── toggleterm.lua  # Terminal integration
│       ├── treesitter.lua  # Treesitter configuration
│       └── utils.lua       # General utilities
└── syntax/
    └── qf.vim             # Quickfix syntax highlighting
```

## Key Patterns

### 1. Plugin Management
- Uses lazy.nvim for lazy-loading and plugin management
- Plugin specs are organized by category in `lua/plugins/`
- Each plugin file returns a table of plugin specifications
- VSCode compatibility is handled with `vim.g.vscode` checks

### 2. Module Loading
- Configuration is modularized in `lua/user/`
- Modules are loaded explicitly in `init.lua`
- VSCode-incompatible modules are conditionally loaded

### 3. Snacks.nvim Integration
- Extensive use of Snacks.nvim for UI enhancements
- Custom picker configurations in `lua/user/snacks.lua`
- File explorer, zen mode, dashboard, and more

### 4. LSP Configuration
- Language servers are configured in `lua/plugins/lsp.lua`
- Custom handlers and utilities in `lua/user/lsp_utils.lua`
- Per-language settings (e.g., Ruby in `lua/user/ruby.lua`)

## Common Tasks

### Adding a New Plugin
1. Create or modify a file in `lua/plugins/`
2. Return a plugin specification table
3. Run `:Lazy sync` to install

Example:
```lua
-- In lua/plugins/mynewplugin.lua
return {
  {
    "author/plugin-name",
    event = "BufReadPost", -- Lazy load on event
    config = function()
      require("plugin-name").setup({
        -- options
      })
    end,
  }
}
```

### Adding Key Mappings
Add mappings to `lua/user/keymaps.lua` or within plugin specs:
```lua
-- Global mapping
vim.keymap.set("n", "<leader>xx", function() ... end, { desc = "Description" })

-- In plugin spec
keys = {
  { "<leader>xx", function() ... end, desc = "Description" }
}
```

### Configuring Language Servers
Modify `lua/plugins/lsp.lua` to add or configure language servers:
```lua
servers = {
  ruby_lsp = {
    settings = {
      -- server-specific settings
    }
  }
}
```

### VSCode Compatibility
Always check for VSCode when adding UI-heavy features:
```lua
if not vim.g.vscode then
  -- UI-specific code
end
```

## Key Bindings Convention

- `<leader>` is space
- `<leader>f*` - Find/search operations (files, grep, etc.)
- `<leader>g*` - Git operations
- `<leader>w*` - Window/workspace operations
- `<leader>x*` - Diagnostics/errors
- `<leader>h*` - Help/documentation
- `<leader>v*` - Vim/config related
- `<leader>r*` - Run/test operations

## Development Workflow

1. **Testing Changes**: Neovim config changes take effect on restart or `:source %`
2. **Plugin Updates**: Use `:Lazy update` to update plugins
3. **Lock File**: Commit `lazy-lock.json` for reproducible installs
4. **Debugging**: Use `_G.dd()` for debug inspection (Snacks.nvim feature)

## Important Notes

- This configuration is symlinked from the Nix store, not managed by Nix directly
- Allows for easier development and testing without rebuilding Nix
- The parent repository uses nix-darwin and Home Manager for system configuration
- TODO.md contains planned improvements and known issues

## Testing

- Test runner integration via vim-test
- Overseer.nvim for task management
- Testing utilities in `lua/user/testing.lua`

## Dependencies

- Neovim 0.9+ required
- Git for plugin management
- Node.js for some language servers
- Specific language tools installed via Nix (see parent config)