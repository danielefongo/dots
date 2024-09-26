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
        PartOf = [ "i3-session.target" ];
      };

      Install = {
        WantedBy = [ "i3-session.target" ];
      };

      Service = {
        ExecStart = "${picom}/bin/picom";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
