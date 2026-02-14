{ lib, pkgs, ... }:

lib.homeOpts.module "system.essentials" { } (_: {
  home.packages = with pkgs; [
    gcc
    cmake
    gnumake
    glibc
    openssl
    openssh
    zip
    unzip
    nfs-utils
  ];
})
