{ config, pkgs, user, home, ... }:

{
  imports = [
    ./alacritty
    ./btop
    ./dunst
    ./docker
    ./firefox
    ./flameshot
    ./fonts
    ./git
    ./gtk
    ./i3
    ./less
    ./mise
    ./nvim
    ./picom
    ./polybar
    ./redshift
    ./rofi
    ./shell-utils
    ./theme
    ./tig
    ./tmux
    ./wallpaper
    ./xbindkeys
    ./xsettingsd
    ./zsh
  ];

  home.username = user;
  home.homeDirectory = home;
  home.packages = [ ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
