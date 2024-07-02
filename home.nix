{ config, pkgs, user, home, ... }:

{
  imports = [
    ./alacritty
    ./btop
    ./dunst
    ./git
    ./less
    ./nvim
    ./picom
    ./polybar
    ./shell-utils
    ./theme
    ./tig
    ./tmux
    ./wallpaper
  ];

  home.username = user;
  home.homeDirectory = home;
  home.packages = [ ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
