{ lib, pkgs, ... }:

lib.homeOpts.module "desktop.waybar" { } (_: {
  home.packages = with pkgs; [
    waybar
  ];

  xdg.configFile."waybar/config".source = pkgs.dot.outLink "waybar/config";
  xdg.configFile."waybar/style.css".source = pkgs.dot.outLink "waybar/style.css";

  mod.home.apps.audio.enable = true;
  mod.home.desktop.playerctl.enable = true;

  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar";
      PartOf = [ "wayland-session.target" ];
    };

    Install = {
      WantedBy = [ "wayland-session.target" ];
    };

    Service = {
      ExecStart = "${lib.getExe pkgs.waybar}";
      Restart = "on-failure";
      RestartSec = 2;
      Environment = [
        "PANGO_ALIASING=1"
      ];
    };
  };
})
