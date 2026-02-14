{ pkgs, dots_path }:

let
  theme_package = pkgs.mkYarnPackage {
    name = "theme";
    src = ./.;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
  };
in
(pkgs.writeShellScriptBin "nix-theme" ''
  DOTS_PATH=${dots_path}

  ${theme_package}/bin/theme "$1" "$DOTS_PATH/themes/base.js" "$DOTS_PATH" "$DOTS_PATH/output"
'')
