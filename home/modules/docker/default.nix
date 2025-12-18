{ lib, pkgs, ... }:

lib.optionalModule "virtualisation.docker" { } (cfg: {
  home.packages = with pkgs; [ docker ];
})
