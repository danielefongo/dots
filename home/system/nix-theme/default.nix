{ lib, pkgs, ... }:

lib.opts.module "system.theme"
  {
    service = {
      type = lib.types.bool;
    };

  }
  (
    cfg:
    lib.mkMerge [
      {
        home.packages = [ pkgs.nix-scripts.nix-theme ];
      }
      (lib.mkIf cfg.service {
        systemd.user.services.theme = {
          Unit.Description = "Theme";

          Service = {
            ExecStart = "${pkgs.nix-scripts.nix-theme}/bin/nix-theme watch";

            Restart = "on-failure";
            RestartSec = 2;
          };
        };
      })
    ]
  )
