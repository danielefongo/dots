{ lib, pkgs, ... }:

lib.homeOpts.module "system.theme"
  {
    service = {
      type = lib.types.bool;
      default = true;
    };
  }
  (
    { moduleConfig, ... }:
    {
      home.packages = [ pkgs.nix-scripts.nix-theme ];

      systemd.user.services.theme = lib.optionalAttrs moduleConfig.service {
        Unit.Description = "Theme";

        Service = {
          ExecStart = "${pkgs.nix-scripts.nix-theme}/bin/nix-theme watch";

          Restart = "on-failure";
          RestartSec = 2;
        };
      };
    }
  )
