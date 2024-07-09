{ lib, pkgs, config, dots_path, ... }:

let
  picom = (lib.wrapNixGL pkgs.picom);
in
{
  home.packages = [
    picom
  ];

  xdg.configFile."picom".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/picom";

  systemd.user.services = {
    picom = {
      Unit = {
        Description = "Picom";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = "${picom}/bin/picom";
        Restart = "on-failure";
      };
    };
  };
}
