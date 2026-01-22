{ pkgs, config, home, ... }: {
  home.packages = with pkgs; [
    mas
    caddy
    libiconv
  ];

  home.sessionVariables = {
    LIBRARY_PATH = "${pkgs.libiconv}/lib";
  };

  home.stateVersion = "24.05";
}
