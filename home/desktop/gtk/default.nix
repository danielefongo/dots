{ lib, pkgs, ... }:

lib.opts.module "desktop.gtk" { } (_: {
  home.packages = with pkgs; [ sassc ];

  home.file.".themes/gtk-theme".source = pkgs.dot.outLink "gtk";
})
