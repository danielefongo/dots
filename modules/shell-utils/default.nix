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
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
