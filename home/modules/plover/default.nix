{ lib, pkgs, ... }:

lib.optionalModule "apps.plover" { } (cfg: {
  home.packages = with pkgs; [
    plover
  ];

  systemd.user.services.plover = {
    Unit = {
      Description = "Plover Stenography Engine";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.plover}/bin/plover";
      Restart = "always";
      RestartSec = 2;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
})
