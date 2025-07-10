{ pkgs, ... }:

{
  home.packages = with pkgs; [
    choose
    cloc
    csvlens
    curl
    dust
    fastmod
    fd
    jq
    kondo
    less
    ncdu
    ripgrep
    tldr
    tree
    xclip
    zoxide
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
