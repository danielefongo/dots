{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.kitty ];

  xdg.configFile."kitty".source = lib.outLink "kitty";
}
