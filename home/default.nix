{ lib, ... }:

{
  imports = lib.modulesIn ./.;

  mod.home.apps.plover.enable = false;
}
