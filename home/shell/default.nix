{ lib, ... }:

lib.homeOpts.module "shell" { } (_: {
  imports = lib.modulesIn ./.;
})
