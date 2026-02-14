{ lib, ... }:

lib.hostOpts.module "networking" { } (_: {
  networking.networkmanager.enable = true;

  networking.useDHCP = lib.mkDefault true;

  services.tailscale.enable = true;
})
