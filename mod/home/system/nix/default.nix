{ lib, pkgs, ... }:

lib.homeOpts.module "system.nix" { } (_: {
  home.packages = with pkgs; [
    fh
    nix-check
    nix-packages
    nix-rebuild
    nix-tools
    nix-update
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
})
