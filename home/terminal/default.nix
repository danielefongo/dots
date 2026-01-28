{ lib, ... }:

lib.opts.module "terminal" { } (cfg: {
  imports = lib.modulesIn ./.;
})
