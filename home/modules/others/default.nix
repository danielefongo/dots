{ lib, pkgs, ... }:

lib.optionalModule "others.tailscale" { } (cfg: {
  home.packages = with pkgs; [
    tailscale
  ];
})
