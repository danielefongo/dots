{ lib, pkgs, ... }:

lib.withCfg "nix_theme"
  {
    polling = {
      type = lib.types.bool;
    };
  }
  (cfg: {
    home.packages = [ pkgs.nix-scripts.nix-theme ];

    systemd.user.services.theme = {
      Unit.Description = "Theme";

      Service = {
        ExecStart =
          if cfg.polling then
            "${pkgs.writeShellScript "nix-theme-runner" ''
              #!/bin/bash
              while true; do
                ${pkgs.nix-scripts.nix-theme}/bin/nix-theme
                sleep 2
              done
            ''}"
          else
            "${pkgs.nix-scripts.nix-theme}/bin/nix-theme watch";

        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  })
