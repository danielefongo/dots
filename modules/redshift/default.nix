{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    redshift
  ];

  xdg.configFile."redshift.conf".source = lib.outLink "redshift/redshift.conf";

  systemd.user.services = {
    redshift = {
      Unit = {
        Description = "Redshift";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = "${pkgs.redshift}/bin/redshift";
        Restart = "on-failure";
      };
    };
  };
}
