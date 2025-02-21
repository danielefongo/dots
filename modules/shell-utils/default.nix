{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zoxide
    curl
    jq
    ncdu
    ripgrep
    tldr
    xclip
    cloc
    choose
    dust
    fastmod
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
