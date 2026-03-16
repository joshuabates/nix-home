{ config, pkgs, ... }:

{
  home.file = {
    ".config/kitty/pass_keys.py".source = ./pass_keys.py;
    ".config/kitty/get_layout.py".source = ./get_layout.py;
    ".config/kitty/kitty.conf" = {
      text = ''
        font_family FiraCode Nerd Font
        font_size 16

        shell_integration no-rc

        active_border_color none
        allow_remote_control yes
        bell_on_tab no
        enable_audio_bell no
        enabled_layouts tall:bias=70;full_size=1;mirrored=false,stack
        focus_follows_mouse yes
        listen_on unix:/tmp/kitty
        macos_quit_when_last_window_closed yes
        scrollback_lines 20000
        shell /run/current-system/sw/bin/fish --login
        tab_bar_edge top
        tab_bar_style powerline
        tab_powerline_style slanted

        map alt+z toggle_layout stack
        map cmd+0 change_font_size all 0
        map cmd+enter no_op
        map cmd+t new_tab
        map ctrl+1 goto_tab 1
        map ctrl+2 goto_tab 2
        map ctrl+3 goto_tab 3
        map ctrl+4 goto_tab 4
        map ctrl+5 goto_tab 5
        map ctrl+6 goto_tab 6
        map ctrl+7 goto_tab 7
        map ctrl+8 goto_tab 8
        map ctrl+enter new_window_with_cwd
        map ctrl+h kitten pass_keys.py left   ctrl+h
        map ctrl+i toggle_layout stack
        map ctrl+j kitten pass_keys.py bottom ctrl+j
        map ctrl+k kitten pass_keys.py top    ctrl+k
        map ctrl+l kitten pass_keys.py right  ctrl+l

        # Gruvbox Material Dark Medium theme
        background #282828
        foreground #d4be98
        selection_background #d4be98
        selection_foreground #282828
        cursor #a89984
        cursor_text_color background
        color0 #665c54
        color8 #928374
        color1 #ea6962
        color9 #ea6962
        color2  #a9b665
        color10 #a9b665
        color3  #e78a4e
        color11 #d8a657
        color4  #7daea3
        color12 #7daea3
        color5  #d3869b
        color13 #d3869b
        color6  #89b482
        color14 #89b482
        color7  #d4be98
        color15 #d4be98
        active_tab_foreground   #444444
        active_tab_background   #d4be98
        inactive_tab_foreground #d4be98
        inactive_tab_background #202020
      '';
    };
  };
}
