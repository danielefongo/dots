{
  lib,
  pkgs,
  user_data,
  scripts,
  ...
}:

{
  nix-theme = pkgs.callPackage ./nix-theme {
    inherit user_data pkgs;
  };

  nix-rebuild = scripts.dotScript "nix-rebuild" ./scripts/nix-rebuild.sh [ ];
  nix-check = scripts.dotScript "nix-check" ./scripts/nix-check.sh [ ];
  nix-packages = scripts.dotScript "nix-packages" ./scripts/nix-packages.sh [ ];
  nix-tools = scripts.dotScript "nix-tools" ./scripts/nix-tools.sh [ ];
  nix-update-flakes = scripts.dotScript "nix-update-flakes" ./scripts/nix-update-flakes.sh [ ];
}
