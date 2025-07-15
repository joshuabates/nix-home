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
    gh
    nss
    overmind
    poetry
    nodejs
    yarn
    pnpm
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
    uv

    nodePackages.typescript-language-server
    vscode-langservers-extracted
    stylelint-lsp
    rubyPackages.solargraph
    lua-language-server
    stylua
    nixd
    # rubyPackages.standard (doesnt exist)
    # cssmodules-language-server (doesnt exist)
    
    ast-grep
    silver-searcher
    ripgrep
    jq
    tree-sitter

    zoxide
    ncurses
  ];

  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-home/config/nvim";
    };
    ".npmrc" = {
      text = ''prefix = ${config.home.homeDirectory}/.npm-global'';
    };
  };

  programs = {
    fzf = {
      enable = true;
      enableFishIntegration = false;
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
