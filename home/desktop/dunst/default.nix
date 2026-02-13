{ lib, pkgs, ... }:

let
  dunstWrapper = pkgs.writeShellScriptBin "dunst" ''
    pid=$(qdbus org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.GetConnectionUnixProcessID org.freedesktop.Notifications)
    if [[ -n "$pid" ]]; then
        kill $pid
    fi

    ${pkgs.dunst}/bin/dunst
  '';
in
lib.opts.module "desktop.dunst" { } (_: {
  xdg.configFile."dunst".source = pkgs.dot.outLink "dunst";

  systemd.user.services = {
    dunst = {
      Unit = {
        Description = "Dunst";
        PartOf = [ "x11-session.target" ];
      };

      Install = {
        WantedBy = [ "x11-session.target" ];
      };

      Service = {
        ExecStart = "${dunstWrapper}/bin/dunst";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
})
