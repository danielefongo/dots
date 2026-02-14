{ lib, pkgs, ... }:

lib.hostOpts.module "steam" { } (_: {
  programs.steam = {
    enable = true;
    package = pkgs.steam;
  };
})
