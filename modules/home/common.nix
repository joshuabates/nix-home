{ pkgs, config, ... }: {

  imports = [ ./programs/git.nix ./programs/fish.nix ./programs/kitty ];
  home.username = "joshuabates";
  # builtins.head (builtins.attrNames config.users);

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
    gcc
    poetry
    nodejs
    yarn
    ruby
    ruby-lsp
    sqlite
    direnv
    lazygit
    awscli2
    aws-mfa

    nodePackages.typescript-language-server
    vscode-langservers-extracted
    stylelint-lsp
    rubyPackages.solargraph
    lua-language-server
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
      source = config.lib.file.mkOutOfStoreSymlink ../../config/nvim;
      recursive = true;
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
