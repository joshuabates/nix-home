{ pkgs, ... }: {

  system = {
    primaryUser = "joshua";
    keyboard.enableKeyMapping = true;
    keyboard.remapCapsLockToControl = true;

    defaults = {  
      NSGlobalDomain = {
        InitialKeyRepeat = 15;
        KeyRepeat = 1;
        AppleInterfaceStyle = "Dark";
        AppleShowAllExtensions = true;
      };

      dock = {
        autohide = true;
        show-recents = false;
      };

      finder = {
        AppleShowAllExtensions = true;
        _FXShowPosixPathInTitle = true;
      };
    };
  };
  security.pam.services.sudo_local.touchIdAuth = true;
  # services.nix-daemon.enable = true;

  # fonts.fontconfig.enable = true;
  
  # backwards compat; don't change?
  system.stateVersion = 5;
}
