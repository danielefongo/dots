{ lib, pkgs, ... }:

lib.opts.module "cli.btop" { } (cfg: {
  home.packages = with pkgs; [ btop ];

  xdg.configFile."btop".source = pkgs.dot.outLink "btop";
})
