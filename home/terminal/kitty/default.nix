{ lib, pkgs, ... }:

lib.opts.module "terminal.kitty" { } (cfg: {
  home.packages = [ pkgs.kitty ];

  xdg.configFile."kitty".source = pkgs.dot.outLink "kitty";
})
