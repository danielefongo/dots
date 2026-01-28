{ lib, pkgs, ... }:

lib.opts.module "cli.opencode" { } (cfg: {
  home.packages = [ pkgs.unstable.opencode ];

  xdg.configFile."opencode/config.json".source = pkgs.dot.outLink "opencode/config.json";
})
