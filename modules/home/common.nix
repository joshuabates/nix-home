{ pkgs, config, ... }: {

  home.username = builtins.head (builtins.attrNames config.users.users);

  home.packages = with pkgs; [
    wget
    curl
    git
    unzip
    htop
    gnugrep
    gnupg
    openssl
    gnumake
    fish
    
    # Development tools
    gcc
    python
    poetry
    nodejs
    yarn
    ruby
    sqlite
    
    # Other utilities
    ripgrep
    jq
    tree-sitter
    lazygit
  ];

  home.file = {
    ".config/nvim".source = config/nvim;
    ".config/fish".source = config/fish;
  };

  programs = {
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
    git.enable = true;
  };
}
