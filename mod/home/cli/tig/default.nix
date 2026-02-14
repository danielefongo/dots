{ lib, pkgs, ... }:

lib.homeOpts.module "cli.tig" { } (_: {
  home.packages = with pkgs; [ tig ];

  xdg.configFile."tig".source = pkgs.dot.outLink "tig";

  mod.home.cli.git.enable = true;
})
