{ lib, pkgs, ... }:

{
  home.packages = [ (lib.wrapNixGL pkgs.alacritty) ];

  xdg.configFile."alacritty".source = lib.outLink "alacritty";
}
