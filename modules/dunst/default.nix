{ pkgs, config, dots_path, ... }:

let
  dunstWrapper = pkgs.writeShellScriptBin "dunst" ''
    error=$(${pkgs.dunst}/bin/dunst 2>&1 > /dev/null)

    if [[ $error == *"Cannot acquire 'org.freedesktop.Notifications'"* ]]; then
        pid=$(echo $error | grep -oP "PID '\K[0-9]+")
        kill $pid
        ${pkgs.dunst}/bin/dunst > /dev/null
    fi
  '';
in
{
  xdg.configFile."dunst".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/dunst";

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
