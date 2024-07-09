{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh
  ];

  home.file.".zshrc".source = lib.outLink "zsh/.zshrc";
}
