{ pkgs, home, ... }:

let
  wallpaper_yarn = pkgs.mkYarnPackage {
    name = "wallpaper";
    src = ../../../wallpaper;
    packageJSON = ../../../wallpaper/package.json;
    yarnLock = ../../../wallpaper/yarn.lock;
    pkgConfig.canvas = {
      buildInputs = with pkgs; [ nodePackages.node-gyp-build nodePackages.node-pre-gyp nodejs cairo freetype libjpeg libpng pango pkg-config pixman python3 giflib ];
      postInstall = ''
        ${pkgs.nodePackages.node-pre-gyp}/bin/node-pre-gyp install --build-from-source --nodedir=${pkgs.nodejs}
      '';
    };
  };

  wallpaper = pkgs.writeShellScriptBin "wallpaper" ''
    ${wallpaper_yarn}/bin/wallpaper "$@"
  '';
in
{
  home.packages = with pkgs; [
    wallpaper
  ];
}
