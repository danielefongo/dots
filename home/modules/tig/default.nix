{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [ tig ];

  xdg.configFile."tig".source = lib.outLink "tig";
}
