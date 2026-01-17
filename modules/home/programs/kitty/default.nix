{ config, pkgs, ... }:

{
  home.file = {
    # ".config/kitty/neighboring_window.py".source = ./neighboring_window.py;
    ".config/kitty/pass_keys.py".source = ./pass_keys.py;
    ".config/kitty/get_layout.py".source = ./get_layout.py;
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 16;
    };
    themeFile = "GruvboxMaterialDarkMedium";
    settings = {
      scrollback_lines = 20000;
      focus_follows_mouse = "yes";
      enable_audio_bell = "no";
      bell_on_tab = "no";
      enabled_layouts = "tall:bias=70;full_size=1;mirrored=false,stack";
      active_border_color = "none";
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      shell = "${pkgs.fish}/bin/fish --login";
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";
      macos_quit_when_last_window_closed = "yes";
    };
    keybindings = {
      "ctrl+enter" = "new_window_with_cwd";
      "cmd+enter" = "no_op";
      "cmd+t" = "new_tab";
      "ctrl+1" = "goto_tab 1";
      "ctrl+2" = "goto_tab 2";
      "ctrl+3" = "goto_tab 3";
      "ctrl+4" = "goto_tab 4";
      "ctrl+5" = "goto_tab 5";
      "ctrl+6" = "goto_tab 6";
      "ctrl+7" = "goto_tab 7";
      "ctrl+8" = "goto_tab 8";
      "ctrl+i" = "toggle_layout stack";
      "alt+z" = "toggle_layout stack";
      # "cmd+equal" = "change_font_size all +2.0";
      # "cmd+minus" = "change_font_size all -2.0";
      "cmd+0" = "change_font_size all 0";
      "ctrl+j" = "kitten pass_keys.py bottom ctrl+j";
      "ctrl+k" = "kitten pass_keys.py top    ctrl+k";
      "ctrl+h" = "kitten pass_keys.py left   ctrl+h";
      "ctrl+l" = "kitten pass_keys.py right  ctrl+l";
    };
  };
}
