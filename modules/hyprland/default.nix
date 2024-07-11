{ lib, pkgs, ... }:

let
  hypr = (lib.wrapNixGL pkgs.hyprland);
in
{
  home.packages = [ hypr ];

  xdg.configFile."hypr".source = lib.outLink "hypr";

  systemd.user.services = {
    hyprland = {
      Unit = {
        Description = "hyprland window manager";
      };
      Service = {
        ExecStart = "${hypr}/bin/hyprland";
        ExecStopPost = "systemctl --user stop --no-block graphical-session.target";
      };
    };
  };

  systemd.user.targets = {
    hyprland-session = {
      Unit = {
        Description = "hyprland session";
        BindsTo = "graphical-session.target";
        Wants = [
          "dunst.service"
          "flameshot.service"
        ];
      };
    };
  };
}
