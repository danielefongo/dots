{ lib, pkgs, ... }:

lib.homeOpts.module "cli.btop" { } (_: {
  home.packages = with pkgs; [ btop ];

  xdg.configFile."btop".source = pkgs.dot.outLink "btop";
})
