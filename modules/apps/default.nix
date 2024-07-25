{ pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password-gui
    spotify
    xfce.thunar
  ];
}
