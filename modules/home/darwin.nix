{ pkgs, config, home, ... }: {
  home.packages = with pkgs; [
    mas
  ];
  home.stateVersion = "24.05";
}
