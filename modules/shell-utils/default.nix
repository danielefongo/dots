{ pkgs, ... }:

{
  home.packages = with pkgs; [
    curl
    ripgrep
    autojump
    tldr
  ];
}
