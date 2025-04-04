{ pkgs, config, ... }: {

  imports = [ ./programs/git.nix ./programs/fish.nix ./programs/kitty ];

  home.packages = with pkgs; [
    fira-code-nerdfont
    wget
    curl
    unzip
    htop
    gnugrep
    gnupg
    openssl
    gnumake
    fish
    delta
    neovim
    fd
    gcc
    nss
    overmind
    poetry
    nodejs
    yarn
    ruby
    ruby-lsp
    rustc
    rustup
    sqlite
    direnv
    lazygit
    awscli2
    aws-mfa
    python3
    python3Packages.pip
    python3Packages.virtualenv
    ffmpeg
    yt-dlp

    nodePackages.typescript-language-server
    vscode-langservers-extracted
    stylelint-lsp
    rubyPackages.solargraph
    lua-language-server
    stylua
    nixd
    # rubyPackages.standard (doesnt exist)
    # cssmodules-language-server (doesnt exist)
    
    silver-searcher
    ripgrep
    jq
    tree-sitter
  ];

  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-home/config/nvim";
    };
  };

  programs = {
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        global = {
          hide_env_diff = true; 
        };
      };
    };
  };
}
