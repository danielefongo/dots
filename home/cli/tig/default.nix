{ lib, pkgs, ... }:

lib.opts.module "cli.tig" { } (cfg: {
  home.packages = with pkgs; [ tig ];

  xdg.configFile."tig".source = pkgs.dot.outLink "tig";

  module.cli.git.enable = true;
})
