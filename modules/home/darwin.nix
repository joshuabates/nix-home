{ pkgs, config, home, ... }: {

  home.homeDirectory = "/Users/joshua";
  # home.homeDirectory = "/Users/joshuabates";
  # config.users.users.${home.username}.home;
  home.packages = with pkgs; [
    mas
  ];
  home.stateVersion = "24.05";
}
