{ pkgs, ... }: {
  homebrew = {
    brewPrefix = "/opt/homebrew/bin";
    enable = true;
    caskArgs.no_quarantine = true;
    onActivation.cleanup = "zap";
    global = {
      brewfile = true;
      # lockfiles = true;
    };

    taps = ["puma/puma"];
    brews = ["puma/puma/puma-dev"];
    casks = [ 
      "1password"
      # "alfred"
      "arq"
      # "contexts"
      "fantastical"
      "jordanbaird-ice"
      # "kitty"
      "microsoft-edge"
      # "bettertouchtool"
      "chatgpt"
      # "cyberduck"
      # "daisydisk"
      # "docker"
      # "figma"
      # "iina"
      # "little-snitch"
      # "plex"
      # "firefox"
      # "spotify"
      # "transmission"
      "visual-studio-code"
      # "brave-browser"
      # "wireshark"
      # "xld"
    ];
    masApps = {
      "Omnivore: Read-it-later" = 1564031042;
      "Shazam: Identify Songs" = 897118787;
      "Tot" = 1491071483;
      # "Plume - Light Menubar Note" = 1513115773;
    };
  };
}
