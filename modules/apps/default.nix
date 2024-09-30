{ pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password-gui
    xfce.thunar
    rawtherapee
    pulseaudio
  ];
}
