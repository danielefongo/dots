{
  pkgs,
  dots_path,
}:

let
  theme_package = pkgs.mkYarnPackage {
    name = "theme";
    src = ./.;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
  };
in
pkgs.dot.script "nix-theme" ''
  ${theme_package}/bin/theme "''${1:-}" "$DOTS_PATH/themes/base.js" "$DOTS_PATH" "$DOTS_PATH/output"
'' [ pkgs.libnotify ]
