{ pkgs, dots_path, config, home, ... }:

{
  home.packages = with pkgs; [
    curl
    fzf
    ripgrep
    autojump
    tldr
  ];
}
