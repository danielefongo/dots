{ lib, pkgs, ... }:

{
  imports = [ ./scripts.nix ];

  home.packages = with pkgs; [
    polybarFull
  ];

  xdg.configFile."polybar".source = lib.outLink "polybar";

  systemd.user.services = {
    polybar = {
      Unit = {
        Description = "Polybar";
        PartOf = [ "i3-session.target" ];
      };

      Install = {
        WantedBy = [ "i3-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.writeShellScript "polybar-runner" ''
          #!/bin/bash

          CONFIG_FILE=$HOME/.config/polybar/config

          while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

          export WLAN=$(${pkgs.iw}/bin/iw dev | awk '$1=="Interface"{print $2}' | head -n1)

          for m in $(${pkgs.polybarFull}/bin/polybar --list-monitors | cut -d":" -f1); do
          	MONITOR=$m ${pkgs.polybarFull}/bin/polybar top -c $CONFIG_FILE &
          done
          sleep infinity
        ''}";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
