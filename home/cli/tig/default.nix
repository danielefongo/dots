{ lib, pkgs, ... }:

lib.opts.module "cli.tig" { } (_: {
  home.packages = with pkgs; [ tig ];

  xdg.configFile."tig".source = pkgs.dot.outLink "tig";

  module.cli.git.enable = true;
})
