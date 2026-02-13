{ lib, ... }:

lib.opts.module "shell" { } (_: {
  imports = lib.modulesIn ./.;
})
