{ lib, ... }:

lib.opts.module "system" { } (cfg: {
  imports = lib.modulesIn ./.;
})
