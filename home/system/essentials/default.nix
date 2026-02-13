{ lib, pkgs, ... }:

lib.opts.module "system.essentials" { } (_: {
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
