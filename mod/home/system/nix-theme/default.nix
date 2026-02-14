{ lib, pkgs, ... }:

lib.homeOpts.module "system.theme" { } (_: {
  home.packages = [ pkgs.nix-scripts.nix-theme ];

  systemd.user.services.theme = {
    Unit.Description = "Theme";

    Service = {
      ExecStart = "${pkgs.nix-scripts.nix-theme}/bin/nix-theme watch";

      Restart = "on-failure";
      RestartSec = 2;
    };
  };
})
