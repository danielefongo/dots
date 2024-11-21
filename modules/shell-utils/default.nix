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
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
