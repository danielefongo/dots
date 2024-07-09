{ lib, pkgs, ... }:

let
  picom = (lib.wrapNixGL pkgs.picom);
in
{
  home.packages = [
    picom
  ];

  xdg.configFile."picom".source = lib.outLink "picom";

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
