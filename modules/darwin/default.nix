{ pkgs, ... }: {
  programs.zsh.enable = true;
  programs.fish.enable = true;

  nixpkgs.config = { allowUnfree = true; allowBroken = true; };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    accept-flake-config = true
  '';

  nix.settings = {
    trusted-users = [ "root" "joshua" ];
    accept-flake-config = true;
    extra-substituters = [
      "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://devenv.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  imports = [
    ./system.nix
    ./environment.nix
    ./homebrew.nix
    ./dnsmasq.nix
    # ./caddy.nix
  ];
}
