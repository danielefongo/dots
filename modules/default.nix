{ lib, ... }:
{
  imports = lib.attrValues (lib.modulesIn ./.);
}
