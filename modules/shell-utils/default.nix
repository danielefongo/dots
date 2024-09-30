{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zoxide
    curl
    jq
    ncdu
    ripgrep
    tldr
    xclip
  ];
}
