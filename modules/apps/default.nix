{ pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password-gui
    xfce.thunar
    rawtherapee
    pulseaudio
    pavucontrol
    peek
    spotify
    slack
    telegram-desktop
    whatsapp-for-linux
    ocr
  ];
}
