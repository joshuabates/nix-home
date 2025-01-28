{ pkgs, config, home, ... }: {
  home.packages = with pkgs; [
    mas
    caddy
  ];
  home.stateVersion = "24.05";
}
