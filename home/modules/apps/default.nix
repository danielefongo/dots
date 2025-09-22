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
    whatsapp-for-linux
    ocr
    deskflow
  ];
}
