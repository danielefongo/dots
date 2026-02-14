{ lib, pkgs, ... }:

lib.homeOpts.module "desktop.picom" { } (_: {
  home.packages = [ pkgs.picom ];

  xdg.configFile."picom".source = pkgs.dot.outLink "picom";

  systemd.user.services = {
    picom = {
      Unit = {
        Description = "Picom";
        PartOf = [ "x11-session.target" ];
      };

      Install = {
        WantedBy = [ "x11-session.target" ];
      };

      Service = {
        ExecStart = lib.getExe pkgs.picom;
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
})
