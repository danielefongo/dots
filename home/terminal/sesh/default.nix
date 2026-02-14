{ lib, pkgs, ... }:

lib.homeOpts.module "terminal.sesh" { } (_: {
  home.packages = with pkgs; [ sesh ];

  xdg.configFile."sesh/sesh.toml".source = pkgs.dot.outLink "sesh/sesh.toml";
})
