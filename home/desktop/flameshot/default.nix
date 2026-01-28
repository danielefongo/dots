{ lib, pkgs, ... }:

lib.opts.module "desktop.flameshot" { } (cfg: {
  home.packages = with pkgs; [ flameshot ];

  xdg.configFile."flameshot".source = pkgs.dot.outLink "flameshot";

  systemd.user.services = {
    flameshot = {
      Unit = {
        Description = "Flameshot";
        PartOf = [ "x11-session.target" ];
      };

      Install = {
        WantedBy = [ "x11-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.flameshot}/bin/flameshot";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
})
