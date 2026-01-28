{ ... }:

{
  programs.tmux = {
    enable = true;

    extraConfig = ''
      # Vim-style pane navigation
      bind -n C-h select-pane -L
      bind -n C-j select-pane -D
      bind -n C-k select-pane -U
      bind -n C-l select-pane -R

      # Main-horizontal layout settings
      set-window-option -g main-pane-height 85%

      # Auto-apply main-horizontal layout when panes change
      set-hook -g after-split-window "select-layout main-horizontal"
      set-hook -g after-new-window "select-layout main-horizontal"
    '';
  };
}
