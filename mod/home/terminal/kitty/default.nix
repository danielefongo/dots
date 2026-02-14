{ lib, pkgs, ... }:

lib.homeOpts.module "terminal.kitty" { } (_: {
  home.packages = [ pkgs.kitty ];

  xdg.configFile."kitty".source = pkgs.dot.outLink "kitty";
})
