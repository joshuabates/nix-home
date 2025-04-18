{ pkgs, ... }: {
  nix = {
    optimise = {
      automatic = true;
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
}
