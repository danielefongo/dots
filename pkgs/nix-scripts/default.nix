{
  lib,
  pkgs,
  user_data,
  ...
}:

{
  nix-theme = pkgs.callPackage ./nix-theme {
    inherit user_data pkgs;
  };

  nix-rebuild = lib.dotScript "nix-rebuild" ./scripts/nix-rebuild.sh [ ];
  nix-check = lib.dotScript "nix-check" ./scripts/nix-check.sh [ ];
  nix-packages = lib.dotScript "nix-packages" ./scripts/nix-packages.sh [ ];
  nix-tools = lib.dotScript "nix-tools" ./scripts/nix-tools.sh [ ];
  nix-update-flakes = lib.dotScript "nix-update-flakes" ./scripts/nix-update-flakes.sh [ ];
}
