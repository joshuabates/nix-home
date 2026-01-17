{ lib, config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      # fishPlugins.forgit
      # fishPlugins.fzf-fish
      zoxide
      bat
      eza
      starship
    ];

    sessionVariables = {
      # SHELL = "fish";
      TERMINAL = "kitty";
      HOMEBREW_PREFIX = "/opt/homebrew";
      forgit_revert_commit = "gfrc";
    };
  };
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = pkgs.lib.importTOML ./starship.toml;
  };
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
      set -g fish_key_bindings fish_vi_key_bindings
      set -e fish_user_paths
      # fish_add_path "./node_modules"
      fish_add_path /usr/local/sbin
      fish_add_path /usr/local/share/npm/bin/
      fish_add_path /opt/homebrew/bin
      fish_add_path ${config.home.homeDirectory}/.npm-global/bin
      # fish_add_path "./bin"
      
      set -x LC_CTYPE en_US.UTF-8
      set -x EDITOR "nvim"
      set -x EVENT_NOKQUEUE 1
      set -x FD_SETSIZE 10000
      zoxide init fish | source
      [ -f $HOMEBREW_PREFIX/share/forgit/forgit.plugin.fish ]; and source $HOMEBREW_PREFIX/share/forgit/forgit.plugin.fish
    '';
    plugins = [
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "8920367cf85eee5218cc25a11e209d46e2591e7a";
          sha256 = "1hqqppna8iwjnm8135qdjbd093583qd2kbq8pj507zpb1wn9ihjg";
        };
      }
    ];
    shellAliases = {
      ls = "eza";
      ssh = "kitty +kitten ssh";
      psg = "ps aux | grep";
      vi = "nvim";
      vim = "nvim";
      rsc = "ruby script/rails c";
      b = "bundle exec";
      # Navigation
      p = "cd ~/Projects";
      oc = "cd ~/Opencounter/Opencounter";
      x = "exit";
      cp = "cp -r";
      cd = "z";
      d = "zi";
      # Git
      g = "git";
      gl = "git log";
      gs = "git st";
      gb = "git branch -a";
      ga = "git add";
      gci = "git ci";
      gr = "git rebase";
      gri = "git rebase --interactive";
      gres = "git reset --soft";
      gc = "git commit -v";
      gca = "git commit -v -a";
      gd = "git diff";
      gm = "git co master";
      gap = "git add --patch";
      gnb = "git co -b";
      grh = "git reset HEAD";
      gpr = "git pull --rebase";
      grc = "git rebase --continue";
      gsl = "git show $(git stash list | cut -d\":\" -f 1)";
      gsp = "git stash && git pull && git stash pop";
      cc = "npx --yes @anthropic-ai/claude-code@latest";
      ccc = "npx --yes @anthropic-ai/claude-code@latest --continue";
      ccr = "npx --yes @anthropic-ai/claude-code@latest --resume";
    };
    # interactiveShellInit = fileContents ./interactiveShellInit.fish;
    # shellInit = fileContents ./shellInit.fish;
  };
  programs.man = {
    enable = true;
    generateCaches = false;
  };
}
