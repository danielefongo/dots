{ pkgs, home, dots_path, ... }:

let
  wallpaper_pkg = pkgs.mkYarnPackage {
    name = "wallpaper";
    src = ./.;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    pkgConfig.canvas = {
      buildInputs = with pkgs; [ nodePackages.node-gyp-build nodePackages.node-pre-gyp nodejs cairo freetype libjpeg libpng pango pkg-config pixman python3 giflib ];
      postInstall = ''
        ${pkgs.nodePackages.node-pre-gyp}/bin/node-pre-gyp install --build-from-source --nodedir=${pkgs.nodejs}
      '';
    };
  };

  wallpaper = pkgs.writeShellScriptBin "wallpaper" ''
    SETTINGS=${dots_path}/output/wallpaper/settings.js
    DESTINATION=${dots_path}/output/wallpaper/background.svg

    ${wallpaper_pkg}/bin/wallpaper "$SETTINGS" "$DESTINATION"

    ${pkgs.feh}/bin/feh --bg-scale "$DESTINATION"
  '';
in
{
  home.packages = with pkgs; [
    wallpaper
  ];

  systemd.user.services = {
    wallpaper = {
      Unit = {
        Description = "Wallpaper";
      };

      Service = {
        Type = "simple";
        ExecStart = "${wallpaper}/bin/wallpaper";
      };
    };
  };
}
