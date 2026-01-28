{ lib, pkgs, ... }:

lib.opts.module "desktop.picom" { } (cfg: {
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
        ExecStart = "${pkgs.picom}/bin/picom --backend xrender --vsync";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
})
