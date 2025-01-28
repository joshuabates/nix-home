{ pkgs, ... }: {
  programs.zsh.enable = true;
  programs.fish.enable = true;

  nixpkgs.config = { allowUnfree = true; allowBroken = true; };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  imports = [
    ./system.nix
    ./environment.nix
    ./homebrew.nix
    ./dnsmasq.nix
    ./caddy.nix
  ];
}
