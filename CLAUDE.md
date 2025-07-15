# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal development environment configuration using Nix flakes, nix-darwin (for macOS), and Home Manager. It provides reproducible system and user configurations across multiple macOS machines.

## Common Commands

### Initial Setup
```bash
# Install Nix (if not already installed)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Apply configuration for the current machine
nix run nix-darwin -- switch --flake .

# Change default shell to fish
chsh -s /run/current-system/sw/bin/fish
```

### Development Commands
```bash
# Apply configuration changes
darwin-rebuild switch --flake .

# Check flake validity
nix flake check

# Update flake inputs
nix flake update

# Show flake info
nix flake show

# Build configuration without switching
nix build .#darwinConfigurations.$(hostname).system
```

## Architecture

### Module Organization
- `flake.nix`: Entry point defining machines and their configurations
- `modules/common.nix`: Shared Nix settings (experimental features, etc.)
- `modules/darwin/`: macOS system-level configurations
  - `default.nix`: Main module aggregating all Darwin configs
  - `system.nix`: System preferences (keyboard, dock, finder)
  - `homebrew.nix`: Declarative Homebrew package management
  - `environment.nix`: System environment variables and paths
- `modules/home/`: User-level configurations via Home Manager
  - `common.nix`: Shared home packages and configs
  - `darwin.nix`: macOS-specific home configurations
  - `programs/`: Individual program configurations (fish, git, kitty)

### Key Patterns
1. **Machine Configuration**: Each machine is defined in `flake.nix` using the `mkDarwinWorkstation` function with username, UID, hostname, and system architecture
2. **Neovim Configuration**: Lives in `config/nvim/` and is symlinked, not managed directly by Nix. This allows for easier development and testing of Neovim configs
3. **Program Modules**: Complex program configurations are separated into individual files under `modules/home/programs/`

### Adding New Machines
To add a new macOS machine, add an entry to `darwinConfigurations` in `flake.nix`:
```nix
newmachine = mkDarwinWorkstation "username" uid "hostname" "aarch64-darwin";
```

### Modifying Configurations
- System-level changes: Edit files in `modules/darwin/`
- User-level changes: Edit files in `modules/home/`
- Package additions: Add to `home.packages` in `modules/home/common.nix`
- Homebrew apps: Add to `homebrew.casks` in `modules/darwin/homebrew.nix`