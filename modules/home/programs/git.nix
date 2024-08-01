{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Joshua Bates";
    userEmail = "joshuabates@gmail.com";
    
    extraConfig = {
      core = {
        editor = "nvim";
        pager = "delta --syntax-theme='gruvbox-dark'";
      };
      merge = {
        defaultToUpstream = true;
        conflictstyle = "diff3";
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      format.pretty = "format:%C(yellow)%h%Creset -%C(red)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset";
      help.autocorrect = 1;
      credential = {
        helper = "cache";
      };
      "credential \"https://github.com\"".username = "joshuabates";
      url."https://".insteadOf = "git://";
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        light = false;
        line-numbers = true;
      };
      diff.colorMoved = "default";
      color = {
        branch = "auto";
        diff = "auto";
        status = "auto";
        ui = "auto";
      };
      "color \"branch\"" = {
        current = "yellow reverse";
        local = "yellow";
        remote = "green";
      };
      "color \"diff\"" = {
        meta = "yellow bold";
        frag = "magenta bold";
        old = "red bold";
        new = "green bold";
      };
      "color \"diff-highlight\"" = {
        oldNormal = "red bold";
        oldHighlight = "red bold 52";
        newNormal = "green bold";
        newHighlight = "green bold 22";
      };
      "color \"status\"" = {
        added = "yellow";
        changed = "green";
        untracked = "cyan";
      };
      init.defaultBranch = "main";
      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
      };
    };

    aliases = {
      st = "status";
      s = "status";
      rs = "reset";
      ci = "commit -v";
      co = "checkout";
      b = "branch --sort=-committerdate";
      br = "branch";
      mt = "mergetool";
      d = "diff";
      di = "diff";
      dc = "diff --cached";
      a = "add";
      ap = "add --patch";
      ae = "add --edit";
      get = "!git fetch && ( git rebase -v origin || ( git stash && ( git rebase -v origin || echo \"WARNING: Run 'git stash pop' manually!\" ) && git stash pop ) )";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(yellow bold)<%an>%Creset' --abbrev-commit --date=relative";
      l = "log --graph --abbrev-commit --date=relative";
      ps = "push";
      fe = "fetch";
      sh = "stash";
      ff = "merge --ff-only";
    };

    ignores = [
      ".DS_Store"
      "*.sw[nop]"
      ".bundle"
      ".env"
      "db/*.sqlite3"
      "log/*.log"
      "rerun.txt"
      "tags"
      "!tags/"
      "tmp/**/*"
      "zzlocal.rb"
      ".powenv"
      "scratch"
    ];
  };
}
