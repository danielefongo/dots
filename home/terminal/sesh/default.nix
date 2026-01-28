{ lib, pkgs, ... }:

lib.opts.module "terminal.sesh" { } (cfg: {
  home.packages = with pkgs; [ sesh ];

  xdg.configFile."sesh/sesh.toml".source = pkgs.dot.outLink "sesh/sesh.toml";
})
