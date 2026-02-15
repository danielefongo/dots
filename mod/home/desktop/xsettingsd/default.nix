{ lib, pkgs, ... }:

lib.homeOpts.module "desktop.xsettingsd" { } (_: {
  home.packages = with pkgs; [ xsettingsd ];

  xdg.configFile."xsettingsd".source = pkgs.dot.outLink "xsettingsd";

  mod.home.desktop.gtk.enable = true;

  systemd.user.services.xsettingsd = {
    Unit = {
      Description = "Xsettingsd";
      PartOf = [ "x11-session.target" ];
    };

    Install = {
      WantedBy = [ "x11-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.xsettingsd}/bin/xsettingsd";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
})
