{ pkgs, ... }:

{
  home.packages = with pkgs; [
    autojump
    curl
    jq
    ncdu
    ripgrep
    tldr
  ];
}
