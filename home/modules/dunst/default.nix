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
lib.optionalModule "x11.dunst" { } (cfg: {
  xdg.configFile."dunst".source = lib.outLink "dunst";

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
