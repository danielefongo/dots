{ pkgs, home, ... }:

{
  home.packages = with pkgs; [
    _1password-gui
    slack
    spotify
    telegram-desktop
    vesktop
    xfce.thunar
  ];
}
