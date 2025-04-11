{ pkgs, lib, ... }: {
  environment = {
    shells = with pkgs; [ bash zsh fish];
    systemPackages = [ pkgs.coreutils pkgs.kitty];
    systemPath = [ "/usr/local/bin" ];
    pathsToLink = [ "/Applications" ];
  };

}
