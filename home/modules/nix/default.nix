{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fh
    nix-scripts.nix-check
    nix-scripts.nix-packages
    nix-scripts.nix-rebuild
    nix-scripts.nix-tools
    nix-scripts.nix-update-flakes
    nix-tests
  ];

  nix.settings = {
    max-jobs = "auto";
    cores = 0;
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
  };
}
