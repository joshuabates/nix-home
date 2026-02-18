{ pkgs, config, ... }: {

  imports = [ ./programs/git.nix ./programs/fish.nix ./programs/kitty ./programs/tmux.nix ];

  home.packages = with pkgs; [
    nerd-fonts.fira-code
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
    # poetry  # broken in nixpkgs - pbs-installer version conflict
    nodejs
    emscripten
    yarn
    pnpm
    bun
    ruby
    ruby-lsp
    rustc
    rustup
    tokei
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
    pm2
    mise

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

  home.activation.claudeSetup = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d ~/.claude/.git ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone git@github.com:joshuabates/claude-config.git ~/.claude
      $DRY_RUN_CMD ~/.claude/bootstrap.sh
    else
      echo "~/.claude already exists, skipping clone"
    fi
  '';

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
  # programs.ssh.startAgent = true;
}
