{ lib, ... }:

{
  imports = lib.modulesIn ./.;

  module.apps.plover.enable = false;
}
