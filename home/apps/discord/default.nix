{ lib, pkgs, ... }:

let
  vesktop = {
    home.packages = [
      (pkgs.makeDesktopItem {
        name = "Vesktop";
        exec = "${lib.getExe pkgs.vesktop}";
        icon = "${pkgs.discord}/share/icons/hicolor/256x256/apps/discord.png";
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
    { moduleConfig, ... }:
    lib.mkMerge [
      (lib.mkIf moduleConfig.vesktop vesktop)
      (lib.mkIf (!moduleConfig.vesktop) discord)
    ]
  )
