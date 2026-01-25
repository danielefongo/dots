{ pkgs, lib, ... }:

{
  imports = lib.modulesIn ./.;

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
    tailscale
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
