{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fh
    nix-scripts.nix-check
    nix-scripts.nix-packages-diff
    nix-scripts.nix-update-flakes
    nix-scripts.nix-rebuild
  ];
}
