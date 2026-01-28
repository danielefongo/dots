{ lib, pkgs, ... }:

lib.opts.module "system.essentials" { } (cfg: {
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
