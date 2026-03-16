{ pkgs, lib, ... }: {
  environment = {
    shells = with pkgs; [ bash zsh fish];
    systemPackages = [ pkgs.coreutils ];
    systemPath = [ "/usr/local/bin" ];
    pathsToLink = [ "/Applications" ];
  };

}
