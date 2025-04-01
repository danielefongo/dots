{ lib, pkgs, ... }:

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
    (lib.wrapNixGL telegram-desktop)
    (lib.wrapNixGL whatsapp-for-linux)
    ocr
    keymapp
    vial
  ];
}
