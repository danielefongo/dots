{ lib, ... }:

lib.homeOpts.module "system" { } (_: {
  imports = lib.modulesIn ./.;
})
