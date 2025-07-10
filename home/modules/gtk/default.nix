{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [ sassc ];

  home.file.".themes/gtk-theme".source = lib.outLink "gtk";
}
