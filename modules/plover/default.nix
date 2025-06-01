{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    plover
  ];

  xdg.configFile."plover/plover.cfg".source = lib.outLink "plover/plover.cfg";

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
}
