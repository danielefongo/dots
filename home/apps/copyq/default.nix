{ lib, pkgs, ... }:

lib.homeOpts.module "apps.copyq" { } (_: {
  home.packages = with pkgs; [
    copyq
  ];

  xdg.configFile."copyq/copyq.conf".source = pkgs.dot.outLink "copyq/copyq.conf";

  services.copyq.enable = true;
})
