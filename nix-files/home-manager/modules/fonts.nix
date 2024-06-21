{ pkgs, home, ... }:

{
  home.packages = with pkgs; [
    jetbrains-mono
  ];
}
