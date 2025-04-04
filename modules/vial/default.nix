{ pkgs, ... }:

{
  home.packages = with pkgs; [
    jq
    keymapp
    vial
  ];
}
