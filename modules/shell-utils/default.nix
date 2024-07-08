{ pkgs, ... }:

{
  home.packages = with pkgs; [
    curl
    fzf
    ripgrep
    autojump
    tldr
  ];
}
