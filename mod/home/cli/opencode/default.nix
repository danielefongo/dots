{ lib, pkgs, ... }:

lib.homeOpts.module "cli.opencode" { } (_: {
  home.packages = [ pkgs.unstable.opencode ];

  xdg.configFile."opencode/config.json".source = pkgs.dot.outLink "opencode/config.json";
})
