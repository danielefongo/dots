{ lib, ... }:

lib.homeOpts.module "editor" { } (_: {
  imports = lib.modulesIn ./.;
})
