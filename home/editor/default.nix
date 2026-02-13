{ lib, ... }:

lib.opts.module "editor" { } (_: {
  imports = lib.modulesIn ./.;
})
