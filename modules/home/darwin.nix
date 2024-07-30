{ pkgs, ... }: {

  home.homeDirectory = config.users.users.${home.username}.home;
  home.packages = with pkgs; [
    mas
  ];
}
