{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.picom ];

  xdg.configFile."picom".source = lib.outLink "picom";

  systemd.user.services = {
    picom = {
      Unit = {
        Description = "Picom";
        PartOf = [ "i3-session.target" ];
      };

      Install = {
        WantedBy = [ "i3-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.picom}/bin/picom --backend xrender --vsync";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
