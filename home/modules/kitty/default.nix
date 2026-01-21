{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.kitty ];

  xdg.configFile."kitty".source = pkgs.outLink "kitty";
}
