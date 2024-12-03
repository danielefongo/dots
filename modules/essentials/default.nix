{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    cmake
    gnumake
    glibc
    openssl
    openssh
  ];
}
