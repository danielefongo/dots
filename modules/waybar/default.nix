{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    sassc
    waybar
  ];

  xdg.configFile."waybar".source = lib.outLink "waybar";

  systemd.user.services = {
    waybar = {
      Unit = {
        Description = "Waybar";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = "${pkgs.waybar}/bin/waybar";
        Restart = "on-failure";
        RestartSec = "5";
      };
    };
  };
}
