{ lib, pkgs, ... }:

lib.optionalModule "x11.flameshot" { } (cfg: {
  home.packages = with pkgs; [ flameshot ];

  xdg.configFile."flameshot".source = lib.outLink "flameshot";

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
