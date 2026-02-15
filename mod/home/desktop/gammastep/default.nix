{
  config,
  lib,
  pkgs,
  ...
}:

let
  isWayland = lib.hasHomeModule config "desktop.wayland";
  sessionTarget = if isWayland then "wayland-session.target" else "x11-session.target";
in
lib.homeOpts.module "desktop.gammastep" { } (_: {
  home.packages = with pkgs; [ gammastep ];

  xdg.configFile."gammastep".source = pkgs.dot.outLink "gammastep";

  systemd.user.services.gammastep = {
    Unit = {
      Description = "Gammastep";
      PartOf = [ sessionTarget ];
    };

    Install = {
      WantedBy = [ sessionTarget ];
    };

    Service = {
      ExecStart = "${lib.getExe pkgs.gammastep} -c %h/.config/gammastep/config.ini";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
})
