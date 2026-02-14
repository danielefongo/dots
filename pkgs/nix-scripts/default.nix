{
  pkgs,
  dots_path,
  dot,
  ...
}:

{
  nix-theme = pkgs.callPackage ./nix-theme {
    inherit dots_path pkgs;
  };

  nix-rebuild = dot.script "nix-rebuild" ./scripts/nix-rebuild.sh [ ];
  nix-check = dot.script "nix-check" ./scripts/nix-check.sh [ ];
  nix-packages = dot.script "nix-packages" ./scripts/nix-packages.sh [ ];
  nix-tools = dot.script "nix-tools" ./scripts/nix-tools.sh [ ];
  nix-update = dot.script "nix-update" ./scripts/nix-update.sh [ pkgs.zsh ];
}
