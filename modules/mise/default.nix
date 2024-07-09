{ lib, ... }:

{
  xdg.configFile."mise".source = lib.outLink "mise";
}
