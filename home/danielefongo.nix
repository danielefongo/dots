{
  user,
  home,
  ...
}:
{
  imports = [
    ../modules/alacritty
    ../modules/apps
    ../modules/btop
    ../modules/discord
    ../modules/docker
    ../modules/dunst
    ../modules/essentials
    ../modules/firefox
    ../modules/flameshot
    ../modules/fonts
    ../modules/fzf
    ../modules/git
    ../modules/gtk
    ../modules/i3
    ../modules/nix
    ../modules/nvim
    ../modules/picom
    ../modules/playerctl
    ../modules/plover
    ../modules/polybar
    ../modules/redshift
    ../modules/rofi
    ../modules/sesh
    ../modules/shell-utils
    ../modules/theme
    ../modules/tig
    ../modules/tmux
    ../modules/wallpaper
    ../modules/webapps
    ../modules/xbindkeys
    ../modules/xsettingsd
    ../modules/zsh
  ];

  home.username = user;
  home.homeDirectory = home;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
