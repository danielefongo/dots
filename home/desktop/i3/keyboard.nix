{ pkgs, ... }:

{
  systemd.user.services = {
    i3-keyboard = {
      Unit = {
        Description = "i3 keyboard speed setter";
        PartOf = [ "x11-session.target" ];
      };

      Install = {
        WantedBy = [ "x11-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.writeShellScript "i3-keyboard-runner" ''
          #!/bin/bash
          xset r rate 200 60

          udevadm monitor --environment --udev | while read -r line; do
            if echo "$line" | grep -q "change"; then
              while read -r detail; do
                if echo "$detail" | grep -q "ID_INPUT_KEYBOARD=1"; then
                  xset r rate 200 60
                  break
                fi
              done
            fi
          done
        ''}";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
