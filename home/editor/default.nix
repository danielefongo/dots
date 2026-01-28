{ lib, ... }:

lib.opts.module "editor" { } (cfg: {
  imports = lib.modulesIn ./.;
})
