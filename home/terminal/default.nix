{ lib, ... }:

lib.opts.module "terminal" { } (_: {
  imports = lib.modulesIn ./.;
})
