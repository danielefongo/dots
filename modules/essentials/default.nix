{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    cmake
    gnumake
  ];
}
