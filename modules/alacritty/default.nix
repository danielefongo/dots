{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.alacritty ];

  xdg.configFile."alacritty".source = lib.outLink "alacritty";
}
