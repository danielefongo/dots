{ pkgs, home, ... }:

{
  home.packages = with pkgs; [
    curl
    zsh
    fzf
    ripgrep
    autojump
    tmux
    btop
  ];
}
