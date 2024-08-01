# Install
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

nix run nix-darwin -- switch --flake .

chsh -s /run/current-system/sw/bin/fish

# TODO:
treesitter?
neovim lsps?
