{ lib, pkgs, ... }:

lib.opts.module "system.fonts" { } (cfg: {
  fonts.fontconfig.enable = true;

  home.packages = with pkgs.nerd-fonts; [
    jetbrains-mono
  ];
})
