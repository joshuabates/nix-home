{ pkgs, ... }: {
  homebrew = {
    brewPrefix = "/opt/homebrew/bin";
    enable = true;
    caskArgs.no_quarantine = true;
    global = {
      brewfile = true;
      # lockfiles = true;
    };
    casks = [ 
      "alfred"
      "firefox"
      "spotify"
      "visual-studio-code"
      "brave-browser"
      "font-sf-mono-nerd-font"
    ];
    taps = [
      "homebrew/core"
      "homebrew/cask"
      "homebrew/cask-fonts"
      "cmacrae/formulae"
    ];
  };
}
