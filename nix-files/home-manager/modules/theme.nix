{ pkgs, home, dots_path, ... }:

let
  templating = pkgs.mkYarnPackage {
    name = "template_colors";
    src = ../../../templating;
    packageJSON = ../../../templating/package.json;
    yarnLock = ../../../templating/yarn.lock;
  };

  theme = pkgs.writeShellScriptBin "theme" ''
    DOTS_PATH=${dots_path}

    ${templating}/bin/template_colors "$1" "$DOTS_PATH/theme.js" "$DOTS_PATH" "$DOTS_PATH/output"
  '';
in
{
  home.packages = with pkgs; [
    theme
  ];

  systemd.user.services = {
    theme = {
      Unit = {
        Description = "Theme";
      };

      Service = {
        ExecStart = "theme watch";
        Restart = "always";
      };
    };
  };
}
