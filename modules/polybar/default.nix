{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    polybarFull
  ];

  xdg.configFile."polybar".source = lib.outLink "polybar";

  systemd.user.services = {
    polybar = {
      Unit = {
        Description = "Polybar";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = lib.scriptToBinary ''
          #!/bin/bash

          CONFIG_FILE=$HOME/.config/polybar/config

          while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

          export WLAN=$(ip link show | grep 'wl' | awk -F' ' '{print $2}' | sed 's/://g')

          for m in $(${pkgs.polybarFull}/bin/polybar --list-monitors | cut -d":" -f1); do
          	MONITOR=$m ${pkgs.polybarFull}/bin/polybar top -c $CONFIG_FILE &
          done
          sleep infinity
        '';
        Restart = "on-failure";
      };
    };
  };
}
