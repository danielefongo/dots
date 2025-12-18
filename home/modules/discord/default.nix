{ lib, pkgs, ... }:

let
  vesktop = pkgs.writeShellScriptBin "vesktop" ''
    ${pkgs.vesktop}/bin/vesktop "$@"
  '';
in
lib.optionalModule "apps.discord" { } (cfg: {
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
    lib.outLink "discord/themes/discord.theme.css";
  xdg.configFile."vesktop/settings/settings.json".source =
    lib.outLink "discord/settings/settings.json";
})
