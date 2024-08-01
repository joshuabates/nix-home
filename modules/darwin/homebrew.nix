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
      "arq"
      "kitty"
      "microsoft-edge"
      "bettertouchtool"
      "chatgpt"
      "cyberduck"
      "daisydisk"
      "docker"
      "figma"
      "iina"
      "little-snitch"
      # "firefox"
      "spotify"
      "transmission"
      "visual-studio-code"
      "brave-browser"
      "wireshark"
      "xld"
      # "font-sf-mono-nerd-font"
    ];
  };
}
