{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    zlib
    ncurses
    mise
  ];

  xdg.configFile."mise".source = lib.outLink "mise";
}
