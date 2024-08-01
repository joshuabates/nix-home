{ pkgs, config, ... }: {

  imports = [ ./programs/git.nix ./programs/fish.nix ./programs/kitty ];
  home.username = "joshuabates";
  # builtins.head (builtins.attrNames config.users);

  home.packages = with pkgs; [
    fira-code-nerdfont
    # nerdfonts.override { fonts = [ "FiraCode" ]; }
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
    
    # Development tools
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

    vscode-langservers-extracted
    stylelint-lsp
    rubyPackages.solargraph
    # rubyPackages.standard (doesnt exist)

    # cssmodules-language-server (doesnt exist)
    
    # Other utilities
    silver-searcher
    ripgrep
    jq
    tree-sitter
    lazygit
  ];

  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink ../../config/nvim;
      recursive = true;
    };
    # "./.config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/modules/shared/config/neovim";
    #".config/fish".source = ../../config/fish;
  };

  programs = {
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
