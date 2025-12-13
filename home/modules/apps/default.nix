{ pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password-gui
    rawtherapee
    pulseaudio
    pavucontrol
    peek
    spotify
    telegram-desktop
    wasistlos
    ocr
    deskflow
    qalculate-gtk
  ];
}
