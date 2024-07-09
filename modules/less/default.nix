{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    less
  ];

  home.file.".lesskey".source = lib.outLink "less/.lesskey";
}
