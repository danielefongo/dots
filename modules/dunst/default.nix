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
{
  xdg.configFile."dunst".source = lib.outLink "dunst";

  systemd.user.services = {
    dunst = {
      Unit = {
        Description = "Dunst";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = "${dunstWrapper}/bin/dunst";
        Restart = "on-failure";
      };
    };
  };
}
