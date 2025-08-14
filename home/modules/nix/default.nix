{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fh
    nix-scripts.nix-check
    nix-scripts.nix-packages
    nix-scripts.nix-update-flakes
    nix-scripts.nix-rebuild
  ];
}
