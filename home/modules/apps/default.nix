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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";

      "image/jpeg" = "pix.desktop";
      "image/jpg" = "pix.desktop";
      "image/png" = "pix.desktop";
      "image/gif" = "pix.desktop";
      "image/bmp" = "pix.desktop";
      "image/tiff" = "pix.desktop";
      "image/webp" = "pix.desktop";
      "image/svg+xml" = "pix.desktop";
      "image/x-icon" = "pix.desktop";
      "image/x-fuji-raf" = "pix.desktop";
    };
  };
}
