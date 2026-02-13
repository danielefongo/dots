{ lib, pkgs, ... }:

lib.opts.module "desktop.redshift" { } (_: {
  home.packages = with pkgs; [ redshift ];

  xdg.configFile."redshift.conf".source = pkgs.dot.outLink "redshift/redshift.conf";

  systemd.user.services = {
    redshift = {
      Unit = {
        Description = "Redshift";
        PartOf = [ "x11-session.target" ];
      };

      Install = {
        WantedBy = [ "x11-session.target" ];
      };

      Service = {
        ExecStart = lib.getExe pkgs.redshift;
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
})
