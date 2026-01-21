{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.picom ];

  xdg.configFile."picom".source = pkgs.outLink "picom";

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
}
