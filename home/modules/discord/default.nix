{ pkgs, ... }:

let
  vesktop = pkgs.writeShellScriptBin "vesktop" ''
    ${pkgs.vesktop}/bin/vesktop "$@"
  '';
in
{
  home.packages = [
    vesktop
    (pkgs.makeDesktopItem {
      name = "Vesktop";
      exec = "vesktop";
      icon = "${pkgs.discord}/share/icons/hicolor/256x256/apps/discord.png";
      desktopName = "Discord";
      startupNotify = true;
      startupWMClass = "Discord";
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
      "x-scheme-handler/discord" = "vesktop.desktop";
    };
  };
}
