{ lib, ... }:

lib.opts.module "shell" { } (cfg: {
  imports = lib.modulesIn ./.;
})
