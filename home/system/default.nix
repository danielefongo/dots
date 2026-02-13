{ lib, ... }:

lib.opts.module "system" { } (_: {
  imports = lib.modulesIn ./.;
})
