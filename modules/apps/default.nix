{ pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password-gui
    slack
    spotify
    telegram-desktop
    xfce.thunar
  ];
}