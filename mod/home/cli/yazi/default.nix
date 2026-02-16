{ lib, pkgs, ... }:

lib.homeOpts.module "cli.yazi" { } (_: {
  programs.yazi.enable = true;

  xdg.configFile."yazi".source = pkgs.dot.outLink "yazi/config";

  mod.home.cli.ripgrep.enable = true;
  mod.home.cli.zoxide.enable = true;
})
