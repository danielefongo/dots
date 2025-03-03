{ pkgs, ... }:

{
  home.packages = with pkgs; [
    choose
    cloc
    csvlens
    curl
    dust
    fastmod
    jq
    ncdu
    ripgrep
    tldr
    xclip
    zoxide
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
