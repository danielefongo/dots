{ lib, pkgs, ... }:

lib.homeOpts.module "system.fonts" { } (_: {
  fonts.fontconfig.enable = true;

  home.packages = with pkgs.nerd-fonts; [
    jetbrains-mono
  ];
})
