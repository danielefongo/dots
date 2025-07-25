{ pkgs, user_data, ... }:

let
  theme_package = pkgs.mkYarnPackage {
    name = "theme";
    src = ./.;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
  };

  theme = pkgs.writeShellScriptBin "theme" ''
    DOTS_PATH=${user_data.dots_path}

    ${theme_package}/bin/theme "$1" "$DOTS_PATH/theme.js" "$DOTS_PATH" "$DOTS_PATH/output"
  '';
in
{
  home.packages = [ theme ];

  systemd.user.services = {
    theme = {
      Unit = {
        Description = "Theme";
      };

      Service = {
        ExecStart = "${theme}/bin/theme watch";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
