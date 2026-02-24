{ lib, pkgs, ... }:

lib.homeOpts.module "apps" { } (_: {
  imports = (lib.modulesIn ./.) ++ [
    (lib.package "apps.onepassword" pkgs._1password-gui)
    (lib.package "apps.rawtherapee" pkgs.rawtherapee)
    (lib.package "apps.pulseaudio" pkgs.pulseaudio)
    (lib.package "apps.pavucontrol" pkgs.pavucontrol)
    (lib.homeOpts.bundle "apps.audio" [
      "apps.pulseaudio"
      "apps.pavucontrol"
    ])
    (lib.package "apps.peek" pkgs.peek)
    (lib.package "apps.spotify" pkgs.spotify)
    (lib.homeOpts.bundle "apps.chat" [
      "apps.telegram"
      "apps.whatsapp"
      "apps.discord"
    ])
    (lib.homeOpts.module "apps.telegram" { } (_: {
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
    (lib.package "apps.deskflow" pkgs.deskflow)
    (lib.package "apps.qalculate" pkgs.qalculate-gtk)
    (lib.package "apps.steam" pkgs.steam)
  ];
})
