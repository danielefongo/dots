{ lib, pkgs, ... }:

let
  vesktop = {
    home.packages = [
      (pkgs.makeDesktopItem {
        name = "Vesktop";
        exec = "vesktop";
        icon = "${pkgs.vesktop}/share/icons/hicolor/256x256/apps/vesktop.png";
        desktopName = "Discord";
        startupNotify = true;
        startupWMClass = "VesktopDiscord";
        terminal = false;
      })
    ];

    xdg.configFile."vesktop/themes/discord.theme.css".source =
      pkgs.dot.outLink "discord/themes/discord.theme.css";
    xdg.configFile."vesktop/settings/settings.json".source =
      pkgs.dot.outLink "discord/settings/settings.json";

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/discord" = "Vesktop.desktop";
      };
    };
  };

  discord = {
    home.packages = [ pkgs.discord ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/discord" = "discord.desktop";
      };
    };
  };
in
lib.opts.module "apps.discord"
  {
    vesktop = {
      type = lib.types.bool;
      default = true;
    };
  }
  (
    cfg:
    lib.mkMerge [
      (lib.mkIf cfg.vesktop vesktop)
      (lib.mkIf (!cfg.vesktop) discord)
    ]
  )
