{ lib, pkgs, ... }:

lib.optionalModule "shell.utils" { } (cfg: {
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
    rip2
    babashka
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
})
