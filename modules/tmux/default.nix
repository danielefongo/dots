{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    tmux
  ];

  home.file.".tmux.conf".source = lib.outLink "tmux/tmux.conf";
}
