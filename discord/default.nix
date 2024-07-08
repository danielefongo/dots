{ pkgs, home, config, dots_path, ... }:

let
  vesktop = pkgs.writeShellScriptBin "vesktop" ''
    ${pkgs.vesktop}/bin/vesktop "$@"
  '';
in
{
  home.packages = with pkgs; [
    vesktop
    (pkgs.makeDesktopItem ({
      name = "Vesktop";
      exec = "vesktop";
      icon = "${pkgs.discord}/share/icons/hicolor/256x256/apps/discord.png";
      desktopName = "Discord";
      startupNotify = true;
      startupWMClass = "Discord";
      terminal = false;
    }))
  ];

  xdg.configFile."vesktop/themes/discord.theme.css".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/discord/themes/discord.theme.css";
  xdg.configFile."vesktop/settings/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/discord/settings/settings.json";
}
