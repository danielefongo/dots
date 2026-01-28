{ lib, pkgs, ... }:

lib.opts.module "apps" { } (cfg: {
  imports = (lib.modulesIn ./.) ++ [
    (lib.package "apps.onepassword" pkgs._1password-gui)
    (lib.package "apps.rawtherapee" pkgs.rawtherapee)
    (lib.package "apps.pulseaudio" pkgs.pulseaudio)
    (lib.package "apps.pavucontrol" pkgs.pavucontrol)
    (lib.opts.bundle "apps.audio" [
      "apps.pulseaudio"
      "apps.pavucontrol"
    ])
    (lib.package "apps.peek" pkgs.peek)
    (lib.package "apps.spotify" pkgs.spotify)
    (lib.opts.module "apps.telegram" { } (cfg: {
      home.packages = [ pkgs.telegram-desktop ];

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
          "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
        };
      };
    }))
    (lib.package "apps.whatsapp" pkgs.wasistlos)
    (lib.package "apps.ocr" pkgs.ocr)
    (lib.package "apps.deskflow" pkgs.deskflow)
    (lib.package "apps.qalculate" pkgs.qalculate-gtk)
  ];
})
