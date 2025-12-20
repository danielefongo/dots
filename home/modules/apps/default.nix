{ pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password-gui
    rawtherapee
    pulseaudio
    pavucontrol
    peek
    pix
    spotify
    telegram-desktop
    whatsapp-for-linux
    ocr
    deskflow
    qalculate-gtk
  ];
}
