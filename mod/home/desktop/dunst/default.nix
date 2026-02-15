{
  config,
  lib,
  pkgs,
  ...
}:

let
  isWayland = lib.hasHomeModule config "desktop.wayland";
  sessionTarget = if isWayland then "wayland-session.target" else "x11-session.target";

  dunstWrapper = pkgs.writeShellScriptBin "dunst" ''
    pid=$(qdbus org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.GetConnectionUnixProcessID org.freedesktop.Notifications)
    if [[ -n "$pid" ]]; then
        kill $pid
    fi

    ${pkgs.dunst}/bin/dunst
  '';
in
lib.homeOpts.module "desktop.dunst" { } (_: {
  xdg.configFile."dunst".source = pkgs.dot.outLink "dunst";

  systemd.user.services.dunst = {
    Unit = {
      Description = "Dunst";
      PartOf = [ sessionTarget ];
    };

    Install = {
      WantedBy = [ sessionTarget ];
    };

    Service = {
      ExecStart = "${dunstWrapper}/bin/dunst";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
})
