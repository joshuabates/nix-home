{ pkgs, lib, ... }: {
  environment = {
    shells = with pkgs; [ bash zsh fish];
    loginShell = pkgs.fish;
    systemPackages = [ pkgs.coreutils ];
    systemPath = [ "/usr/local/bin" ];
    pathsToLink = [ "/Applications" ];
  };

}
