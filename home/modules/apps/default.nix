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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
    };
  };
}
