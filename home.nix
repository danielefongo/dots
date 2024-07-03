{ config, pkgs, user, home, ... }:

{
  imports = [
    ./alacritty
    ./btop
    ./dunst
    ./firefox
    ./flameshot
    ./fonts
    ./git
    ./gtk
    ./i3
    ./less
    ./nvim
    ./picom
    ./polybar
    ./redshift
    ./rofi
    ./scripts
    ./shell-utils
    ./theme
    ./tig
    ./tmux
    ./wallpaper
    ./xsettingsd
  ];

  home.username = user;
  home.homeDirectory = home;
  home.packages = [ ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
