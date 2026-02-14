{ lib, ... }:

lib.homeOpts.module "terminal" { } (_: {
  imports = lib.modulesIn ./.;
})
